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

Motor = {}
Motor.__index = Motor

function Motor.create(self,STEP,DIR,COURSE,FDC)
    local self = {}
    setmetatable(self, Motor)

    self.STEP = STEP
    self.DIR = DIR
    self.FDC = FDC
    self.COURSE = COURSE
    self.step = 0
    self.angle = 0
    gpio.mode(FDC, gpio.INPUT)
    gpio.mode(STEP, gpio.OUTPUT) -- STEP
    gpio.write(STEP,gpio.LOW)
    gpio.mode(DIR,  gpio.OUTPUT) -- DIR
    return self
end

function Motor.count(self,sens)
    if sens==1 then
    self.step = self.step + 1
    else
    self.step = self.step - 1
    end
    print("Count",self.step)
    end

function Motor.check_fdc(self)
     if (gpio.read(self.FDC)==gpio.LOW) then
     self.step = 0
     end
end

function Motor.set_step(self, sens, step, ddelay)
    print("Motor set step")
    print(self.step)
    if sens == 1 then
        gpio.write(self.DIR,gpio.HIGH)
    else
        gpio.write(self.DIR,gpio.LOW)
    end
    -- Do Steps
    mytimer = tmr.create()
    for i=0,step do
        self.step = self.step + sens
        self:check_fdc()
        gpio.write(self.STEP,gpio.LOW)
        tmr.delay(ddelay*1000)
        gpio.write(self.STEP,gpio.HIGH)
        tmr.delay(ddelay*1000)
        gpio.write(self.STEP,gpio.LOW)
    end
end

function Motor.set_pos(self,angle)
    if (angle<self.step) then
        sens = 0
    else
        sens = 1
    end
        print(self.step)
        self:set_step(sens,abs(angle-self.step),10)
        print("Motor - set_angle done!")
        print(self.step)
    end

function abs(number)
    if number>0 then 
        return number
    else 
        return -number
    end
end

function Motor.init_seq(self)
    print("Motor Init")
    sens = 1 -- First try in sens 1
    while(gpio.read(self.FDC) ~= gpio.LOW) do
        self.set_step(sens, 1, 10)
        if abs(self.step)>self.COURSE then
            if(sens == 0) then
                break
            end
        end
    end
    sens = 0
    self.step = 0
    print("Motor - FDC found")
    print(self.step)
end

mt_plate = Motor:create(7,8,500,0)
mt_lift = Motor:create(2,3,4700,5)



    --VERSION BOARD RPI B REV 2 !       
    function sequence()
        mt_plate:init_seq()
        mt_plate:set_pos(-100)
        print("sequence end")
        end
        --set_up_down("down")

print("Hi HAL.LUA")
sequence()
