import RPi.GPIO as GPIO
import time
def set_motor(sens, step):
	GPIO.setmode(GPIO.BOARD)
	GPIO.setup(12, GPIO.OUT) # STEP
	GPIO.setup(11, GPIO.OUT) # DIR
	if sens == 1:
		GPIO.output(11,GPIO.HIGH)
	else:
		GPIO.output(11,GPIO.LOW)
	for i in range(0,step):
		GPIO.output(12,GPIO.LOW)
		time.sleep(0.01)
		GPIO.output(12,GPIO.HIGH)
		print(step)
	GPIO.output(12,GPIO.LOW)

def sequence():
	set_motor(1,10)
	time.sleep(1)
	set_motor(0,10)
	time.sleep(1)
	set_motor(1,200)
	time.sleep(1)
	set_motor(0,200)
