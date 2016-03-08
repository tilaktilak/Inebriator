import RPi.GPIO as GPIO
import time
def set_motor(motor, sens, step, delay):
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
		time.sleep(delay)
		GPIO.output(STEP,GPIO.HIGH)
		print(step)
	GPIO.output(STEP,GPIO.LOW)

def set_angle(sens, step):
	motor = 1
	set_motor(1, sens, step,0.01)

def set_up_down(direction):
	hauteur = 4700
	motor = 1
	if direction=="up":
		set_motor(motor,0,hauteur,0.001)
	else :
		set_motor(motor,1,hauteur,0.001)

def sequence():
	set_up_down("up")
	time.sleep(1)
	set_up_down("down")
#	set_angle(0,10)
#	time.sleep(1)
#	set_angle(1,200)
#	time.sleep(1)
#	set_angle(0,200)

#sequence()
