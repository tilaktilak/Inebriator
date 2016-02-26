import RPi.GPIO as GPIO
import time

def init_motor(motor):
	GPIO.setmode(GPIO.BOARD)
	if motor ==1:
		STEP = 12
		DIR  = 11
		FDC  = 13
        else:
		return
	GPIO.setup(STEP,GPIO.OUT)
	GPIO.setup(DIR,GPIO.OUT)
	GPIO.setup(FDC, GPIO.IN, GPIO.PUD_UP)
	""" Define DIR statically """
	GPIO.output(DIR,GPIO.HIGH)
	
	while GPIO.input(FDC) != GPIO.LOW:
		GPIO.output(STEP,GPIO.HIGH)
		time.sleep(0.01)
		GPIO.output(STEP,GPIO.LOW)
	""" Here we have an idea of zero position """
	""" Go backward then forward slownly """
	GPIO.output(DIR,GPIO.LOW)
	for i in range(0,20):
		GPIO.output(STEP,GPIO.LOW)
		time.sleep(0.01)
		GPIO.output(STEP,GPIO.HIGH)
		time.sleep(0.01)
	
	while GPIO.input(FDC) != GPIO.LOW:
		GPIO.output(STEP,GPIO.HIGH)
		time.sleep(0.1)
		GPIO.output(STEP,GPIO.LOW)
		time.sleep(0.1)
	
# Motor Number, Sens, Nb of step, Speed in rps	
def set_motor(motor, sens, step, speed):
	GPIO.setmode(GPIO.BOARD)
	if motor == 1:
		STEP = 12
		DIR = 11
                NB_STEP = 200 
	else:
		return

	GPIO.setup(STEP, GPIO.OUT) # STEP
	GPIO.setup(DIR, GPIO.OUT) # DIR
	if sens == 1:
		GPIO.output(DIR,GPIO.HIGH)
	else:
		GPIO.output(DIR,GPIO.LOW)
	for i in range(0,step):
		GPIO.output(STEP,GPIO.HJGH)
		time.sleep(speed/(NB_STEP*2))
		GPIO.output(STEP,GPIO.LOW)
		time.sleep(speed/(NB_STEP*2))

def set_angle(sens, step):
	set_motor(1, sens, step,2)

def set_up_down(direction):
	if direction=="up":
		set_motor(2,1,20,2)
	else :
		set_motor(2,0,20,2)

def sequence():
	set_angle(1,10)
	time.sleep(1)
	set_angle(0,10)
	time.sleep(1)
	set_angle(1,200)
	time.sleep(1)
	set_angle(0,200)
