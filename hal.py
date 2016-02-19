import RPi.GPIO as GPIO
import time
def set_motor(motor, sens, step):
	GPIO.setmode(GPIO.BOARD)
	if motor == 1:
		STEP = 12
		DIR = 11
	else:
		return
	GPIO.setup(STEP, GPIO.OUT) # STEP
	GPIO.setup(DIR, GPIO.OUT) # DIR
	if sens == 1:
		GPIO.output(DIR,GPIO.HIGH)
	else:
		GPIO.output(DIR,GPIO.LOW)
	for i in range(0,step):
		GPIO.output(STEP,GPIO.LOW)
		time.sleep(0.01)
		GPIO.output(STEP,GPIO.HIGH)
		print(step)
	GPIO.output(STEP,GPIO.LOW)

def set_angle(sens, step):
	set_motor(1, sens, step)

def set_up_down(direction):
	if direction=="up":
		set_motor(2,1,20)
	else :
		set_motor(2,0,20)

def sequence():
	set_angle(1,10)
	time.sleep(1)
	set_angle(0,10)
	time.sleep(1)
	set_angle(1,200)
	time.sleep(1)
	set_angle(0,200)
