-- vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
--import RPi.gpio as gpio
--import time

--gpio.setmode(gpio.BCM)

FDC_plate = 17
FDC_lift = 22

step_plate = 0
step_lift = 0

lift = 0
plate = 1

Motor= {STEP = 0, DIR = 0, COURSE = 0, FDC = 0, nbstep = 0, angle = 0, speed = 0}
function Motor:create(o,STEP,DIR,COURSE,FDC)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Motor:settings(STEP,DIR,COURSE,FDC,SPEED)
    self.STEP = STEP
    self.DIR = DIR
    self.FDC = FDC
    self.COURSE = COURSE
    self.nbstep = 0
    self.angle = 0
    self.speed = SPEED



    print("step ",STEP)
    print("dir ",DIR)
    print("course ",COURSE)
    print("fdc ",FDC)
    gpio.mode(FDC, gpio.INPUT)
    gpio.mode(STEP, gpio.OUTPUT) -- STEP
    gpio.write(STEP,gpio.LOW)
    gpio.mode(DIR,  gpio.OUTPUT) -- DIR
end

function Motor:count(sens)
    if sens==1 then
    self.nbstep = self.nbstep + 1
    else
    self.nbstep = self.nbstep - 1
    end
    --print("Count",self.nbstep)
    end

function Motor:check_fdc()
     if (gpio.read(self.FDC)==gpio.LOW) then
     self.nbstep = 0
     end
end

-- On prend des FDC tapped lorsque que le lift est proche du bas, du coup
-- on ne va pas exactement à la consigne d'angle

function Motor:set_step(check, sens, step, ddelay)
    --print("Motor set step")
    if sens == 1 then
        gpio.write(self.DIR,gpio.HIGH)
    else
        gpio.write(self.DIR,gpio.LOW)
    end
    -- Do Steps
    mytimer = tmr.create()
    for i=0,step do
        self:count(sens)
        if(check==1) then
            self:check_fdc()
        end
        gpio.write(self.STEP,gpio.LOW)
        tmr.delay(ddelay)
        gpio.write(self.STEP,gpio.HIGH)
        tmr.delay(ddelay)
        --gpio.write(self.STEP,gpio.LOW)
    end
end

function abs(number)
    if number>0 then 
        return number
    else 
        return -number
    end
end

function Motor:set_pos(angle)

    print("angle:",angle)
    print("nbstep:",self.nbstep)
    if (angle<self.nbstep) then
        sens = 0
    else
        sens = 1
    end      
    CHECK = 1
    self:check_fdc()
    if(self.nbstep == 0) then 
        CHECK = 0 -- We are at FDC, no check
    end
    self:set_step(CHECK,sens,abs(angle-self.nbstep),self.speed)
    print("Motor - set_angle done!",self.nbstep)
end


function Motor:init_seq(sens)
    print("Motor Init")
    sens = sens or 1 -- First try in sens 1
    while(gpio.read(self.FDC) ~= gpio.LOW) do
    --print(sens)
        self:set_step(1,sens, 1, self.speed)
        if abs(self.nbstep)>self.COURSE then
            if(sens == 0) then
                break
            end
            sens = 0
        end
    end
    sens = 0
    self.nbstep = 0
    print("Motor - FDC found")
    print(self.nbstep)
end

mt_plate = Motor:create()
mt_plate:settings(7,8,500*8,0,50)
mt_lift = Motor:create()
mt_lift:settings(2,12,4700,5,1)
   
function sequence()
    --mt_plate:init_seq()
    --mt_plate:set_pos(400)
    --mt_plate:set_pos(-400)
    print("sequence end")
end

function init()
    mt_plate:init_seq()
    mt_lift:init_seq(0)
    print("Initialization OK")
        --set_up_down("down")
end

function go_home()
    mt_plate:set_pos(0)
    if mt_plate.nbstep > 0 then
    sens = 1
    else 
    sens = 0
    end
    while(mt_plate.nbstep < mt_plate.COURSE) do
        mt_plate:set_step(1,sens, 1, mt_plate.speed)
        if (gpio.read(mt_plate.FDC)==gpio.LOW) then
            self.nbstep = 0
            break
        end
    end
    while(gpio.read(mt_lift.FDC)==gpio.LOW) do
        mt_lift:set_step(1,1,1,self.speed)
    end
        --self:set_step(sens,abs(angle-self.nbstep),10)

end

function give_hard(position,quantity)
    if(position==1) then angle=420*8 end
    if(position==2) then angle=640*8 end
    if(position==3) then angle=880*8 end
    if(position==4) then angle=1100*8 end
    if(position==5) then angle=0*8 end
    if(position==6) then angle=0*8 end
    mt_plate:set_pos(angle)
    mt_lift:set_pos(4000);
    tmr.delay(quantity*1000000)
    mt_lift:set_pos(0);
end

function set_plate(angle)
    mt_plate:set_pos(angle)
end

function set_lift(angle)
    mt_lift:set_pos(angle)
end



function give_soft(position,quantity)
    if(position==1) then angle=915*8 end
    if(position==2) then angle=1015*8 end
    if(position==3) then angle=0*8 end
    if(position==4) then angle=0*8 end
    mt_plate:set_pos(angle)
    -- 0.1  = +90
    -- 0.75 = 0
    -- 0.05 = -90
    pwm.setup(4, 50000,0.1*1023)
    pwm.start(4)
    tmr.delay(quantity*1000000)
    pwm.setup(4, 50000,0.05*1023)
    pwm.stop(4)

end
function test()
    --gpio.mode(5,gpio.INPUT)
    --gpio.mode(0,gpio.INPUT)
    print("PLATE : ")
    print(mt_plate.DIR)

    print("LIFT : ")
    print(mt_lift.DIR)
    while(1) do
        tmr.delay(1)
        if(gpio.read(mt_plate.FDC)==gpio.LOW) then
            print("FDC PLATE");
        end
        if(gpio.read(mt_lift.FDC)==gpio.LOW) then
            print("FDC LIFT");
        end
    end
end


servo = {}
servo.pin = 4 --this is GPIO2
servo.value = 2000
servo.id = "servo"
gpio.mode(servo.pin,gpio.OUTPUT)
gpio.write(servo.pin,gpio.LOW)

function set_servo(value)
    servo.value=value
    print("Servo.value,",servo.value)
    for i=0,10 do
        gpio.write(servo.pin, gpio.HIGH)
        tmr.delay(servo.value)
        gpio.write(servo.pin, gpio.LOW)
        tmr.delay(20000-servo.value)
    end
end

function test_servo()

    print("Test SERVO")
    print("END Test SERVO")
end

print("HAL.LUA : Initialization start")
init()
test_servo()
--give_hard(1,4)
--give_hard(2,4)
print("HAL.LUA : Initialization OK")
