# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
import RPi.GPIO as GPIO
import time

GPIO.cleanup()
GPIO.setmode(GPIO.BCM)
print "In hal.py : Set GPIO in BCM Mode"
#GPIO.setup(22, GPIO.IN, pull_up_down=GPIO.PUD_UP)
#GPIO.add_event_detect(17, GPIO.FALLING)

FDC_plate = 17
FDC_lift = 22

step_plate = 0
step_lift = 0

lift = 0
plate = 1
class Motor:
	def __init__(self,STEP,DIR,COURSE,SPEED,FDC=0xFFFF):
		self.STEP = STEP
		self.DIR = DIR
		self.FDC = FDC
		self.COURSE = COURSE
                self.SPEED = SPEED
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
		self.set_step(sens,abs(angle-self.step),self.SPEED)
		print("Motor - set_angle done!")
		print(self.step)

	def init_seq(self):
		sens = 1 # First try in sens 1
		while(GPIO.input(self.FDC) != GPIO.LOW):
			self.set_step(sens, 1, self.SPEED)
			if abs(self.step)>self.COURSE:
                            if(sens == 0): 
					break
			    sens = 0
		self.step = 0
		print("Motor - FDC found!")
		print(self.step)

        def up(self):
            print "Lift UP"
            self.set_step(1,5400,0.001)
            #self.set_step(1,6200,0.001)
        def down(self):
            print "Lift DOWN"
            while(GPIO.input(self.FDC) != GPIO.LOW):
                self.set_step(0, 1, 0.001)

# Instantiate 2 motors objects
mt_plate = Motor(3,4,500,0.015,17)
mt_lift = Motor(18,27,4700,0.01,22)


def set_pwm1(angle,quantity):
	GPIO.setup(23,GPIO.OUT)
	p = GPIO.PWM(23,40)
        print "Servo Angle"
	p.start(angle)
	time.sleep(quantity)
	#.ChangeDutyCycle(angle)
	#time.sleep(quantity)
        print "Servo Zero"
	p.ChangeDutyCycle(9.5)
	time.sleep(1)
        print "Servo STOP"
	p.stop()

def init_pwm():
	GPIO.setup(23,GPIO.OUT)
	p = GPIO.PWM(23,40)
        print "Servo Angle"
	p.start(9.1)
        time.sleep(1)
        p.stop()
        

#VERSION BOARD RPI B REV 2 !	

def init():
    #GPIO.cleanup()
    mt_lift.down()
    mt_plate.init_seq()

def numtoposhard(number):
    if(number == 2):
        return -210
    if(number == 3):
        return -430
    if(number == 4):
        return -650
    if(number == 5):
        return -870
    return 0

def numtopossoft(number):
    if(number == 2):
        return -260
    if(number == 3):
        return -360
    return 0

def give_hard(number,quantity):
        print " Give hard" + str(number)
        mt_plate.set_pos(numtoposhard(number))
        mt_lift.up()
        time.sleep(quantity)
        mt_lift.down()

def give_soft(number, quantity):
    print " Give Soft" + str(number)
    mt_plate.set_pos(numtopossoft(number))
    set_pwm1(6.5,quantity)

def go_home():
    print "Going Home"
    mt_plate.set_pos(0)


def sequence():
        #GPIO.setup(23,GPIO.OUT)
        #p = GPIO.PWM(23,50)
        #p.start(7.5)
	mt_plate.init_seq()
        mt_plate.set_pos(-200)
        set_up_down("up")
        time.sleep(5)
        set_up_down("down")
        time.sleep(1)
        mt_plate.set_pos(-400)


        #mt_lift.set_pos(10)
        set_pwm1(11)
        #mt_lift

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

def set_up_down(direction):
        nb_step = 6300
        motor = 0
        delay = 0.001
#       Init FDC switch
        init_motor(motor)
        if direction == "down":
            dire = 0
        else:
            dire = 1
        set_motor_dir(motor,dire)
        while (nb_step>0):
            if direction == "down" and GPIO.input(FDC_lift)==GPIO.LOW:
                print("Done")
                nb_step = 0
            else:
                 step_motor(0,delay)
                 nb_step=nb_step  
           
#sequence()
#set_pwm1(7,3)
init()
init_pwm()
#mt_lift.up()
#time.sleep(1)
#mt_lift.down()
#mt_plate.set_pos(2000)
#give_hard(4,1)
#give_soft(2,1)
#give_soft(3,1)
#set_pwm1(6.9,3)
#go_home()
