# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
import RPi.GPIO as GPIO
import time

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

        def up(self):
            self.set_step(1,6300,0.001)
        def down(self):
            while(GPIO.input(self.FDC) != GPIO.LOW):
                self.set_step(sens, 1, 0.01)

# Instantiate 2 motors objects
mt_plate = Motor(3,4,500,17)
mt_lift = Motor(27,18,4700,22)


def set_pwm1(angle,quantity):
	GPIO.setup(23,GPIO.OUT)
	p = GPIO.PWM(23,50)
	p.start(7.5)
	time.sleep(3)
	p.ChangeDutyCycle(angle)
	time.sleep(quantity)
	p.ChangeDutyCycle(7.5)
	time.sleep(3)
	p.stop()

#VERSION BOARD RPI B REV 2 !	

def init():
    #GPIO.cleanup()
    mt_plate.init_seq()
    mt_lift.down()

def numtoposhard(number):
    if(1):
        return -200
    return 0

def numtopossoft(number):
    if(1):
        return -400
    return 0

def give_hard(number,quantity):
    for i in quantity:
        mt_plate.set_pos(numtoposhard(number))
        mt_lift.up()
        time.sleep(5)
        mt_lift.down()

def give_soft(number, quantity):
    mt_plate.set_pos(numtopossoft(number))
    set_pwm1(11,quantity)

def go_home():
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

        
#sequence()
#set_up_down("down")

#if GPIO.event_detected(17):
#    print "Done"
#if GPIO.input(17)==GPIO.LOW:
#    print "17 = LOW"
#else:
#    print "17 = HIGH"
#set_pwm1(11)
