# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

FDC_plate = 17
FDC_lift = 22

step_plate = 0
step_lift = 0

lift = 0
plate = 1
class Motor:
	def __init__(self,STEP,DIR,COURSE,FDC=0xFFFF):
		self.STEP = STEP
		self.DIR = DIR
		self.FDC = FDC
		self.COURSE = COURSE
		self.step = 0
		self.angle = 0
		GPIO.setup(FDC, GPIO.IN, pull_up_down=GPIO.PUD_UP)
		GPIO.setup(self.STEP, GPIO.OUT) # STEP
		GPIO.setup(self.DIR, GPIO.OUT) # DIR

	def count(self,sens):
		if sens==1 :
			self.step += 1
		else: 
			self.step -= 1
	def check_fdc(self):
		if(GPIO.input(self.FDC)==GPIO.LOW):
			self.step = 0

	def set_step(self,sens, step, delay):
		if sens == 1:
			GPIO.output(self.DIR,GPIO.HIGH)
		else:
			GPIO.output(self.DIR,GPIO.LOW)
	# Do Steps
		for i in range(0,step):
			self.count(sens)
			self.check_fdc()
			GPIO.output(self.STEP,GPIO.LOW)
			time.sleep(delay)
			GPIO.output(self.STEP,GPIO.HIGH)
			time.sleep(delay)
		GPIO.output(self.STEP,GPIO.LOW)

	def set_pos(self,angle):
		if(angle<self.step):
			sens = 0
		else: 
		 	sens = 1
		print(self.step)
		self.set_step(sens,abs(angle-self.step),0.01)
		print("Motor - set_angle done!")
		print(self.step)

	def init_seq(self):
		sens = 1 # First try in sens 1
		while(GPIO.input(self.FDC) != GPIO.LOW):
			self.set_step(sens, 1, 0.01)
			if abs(self.step)>self.COURSE:
				if(sens == 0): 
					break
				sens = 0
		self.step = 0
		print("Motor - FDC found!")
		print(self.step)



mt_plate = Motor(3,4,500,17)
mt_lift = Motor(27,18,4700,22)

def set_motor(motor, sens, step, delay):
	if motor == plate:
		STEP = 3
		DIR = 4
	else:
		DIR = 27
		STEP = 18
	GPIO.setup(STEP, GPIO.OUT) # STEP
	GPIO.setup(DIR, GPIO.OUT) # DIR
# Define Sens
	if sens == 1:
		GPIO.output(DIR,GPIO.HIGH)
	else:
		GPIO.output(DIR,GPIO.LOW)
# Do Steps
	for i in range(0,step):
		
		GPIO.output(STEP,GPIO.LOW)
		time.sleep(delay)
		GPIO.output(STEP,GPIO.HIGH)
		time.sleep(delay)
#print(step)
	GPIO.output(STEP,GPIO.LOW)

def init_motor(motor):
	if motor == 1:
		STEP = 3
		DIR = 4
	else:
		DIR = 27
		STEP = 18
	GPIO.setup(STEP, GPIO.OUT) # STEP
	GPIO.setup(DIR, GPIO.OUT) # DIR

def set_motor_dir(motor,dir):
	if motor == 1:
		DIR = 4
	else:
		DIR = 27
	GPIO.output(DIR,GPIO.HIGH if (dir==1) else GPIO.LOW)

def step_motor(motor,delay):
	if motor == 1:
		STEP = 3
	else:
		STEP = 18
	GPIO.output(STEP,GPIO.LOW)
	time.sleep(delay)
	GPIO.output(STEP,GPIO.HIGH)
	time.sleep(delay)

#def set_angle(sens, step):
#	motor = 1
#	set_motor(1, sens, step,0.01)

def set_up_down(direction):
	nb_step = 4700
	motor = 0
	delay = 0.001
#	Init FDC switch
	GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	GPIO.add_event_detect(17, GPIO.FALLING)
	init_motor(motor)
	if direction == "down":
		dire = 0
	else:
		dire = 1
	set_motor_dir(motor,dire)
	while (nb_step>0):
		if GPIO.event_detected(17):
			print("Done")
		else:
			step_motor(0,delay)
			nb_step=nb_step - 1


#	if direction=="down":
#		set_motor(motor,0,hauteur,0.001)
#	else :
#		set_motor(motor,1,hauteur,0.001)

def set_pwm1(angle):
	GPIO.setup(23,GPIO.OUT)
	p = GPIO.PWM(23,50)
	p.start(7.5)
	time.sleep(3)
	p.ChangeDutyCycle(angle)
	time.sleep(3)
	p.ChangeDutyCycle(10)
	time.sleep(3)
	p.stop()
#	t = 0.001
#	while 1:
#		GPIO.output(23,GPIO.HIGH)
#		time.sleep(t)
#		GPIO.output(23,GPIO.LOW)
#		time.sleep(0.2-t)

#VERSION BOARD RPI B REV 2 !	
def sequence():
	mt_plate.init_seq()
	mt_plate.set_pos(-100);
#set_up_down("down")


sequence()
