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

Motor= {STEP = 0, DIR = 0, COURSE = 0, FDC = 0, nbstep = 0, angle = 0}
function Motor:create(o,STEP,DIR,COURSE,FDC)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.STEP = STEP
    self.DIR = DIR
    self.FDC = FDC
    self.COURSE = COURSE
    self.nbstep = 0
    self.angle = 0


    print("step ",STEP)
    print("dir ",DIR)
    print("course ",COURSE)
    print("fdc ",FDC)
    gpio.mode(FDC, gpio.INPUT)
    gpio.mode(STEP, gpio.OUTPUT) -- STEP
    gpio.write(STEP,gpio.LOW)
    gpio.mode(DIR,  gpio.OUTPUT) -- DIR
    return o
end

function Motor:count(sens)
    if sens==1 then
    self.nbstep = self.nbstep + 1
    else
    self.nbstep = self.nbstep - 1
    end
    print("Count",self.nbstep)
    end

function Motor:check_fdc()
     if (gpio.read(self.FDC)==gpio.LOW) then
     self.nbstep = 0
     end
end

function Motor:set_step(sens, step, ddelay)
    print("Motor set step")
    if sens == 1 then
        gpio.write(self.DIR,gpio.HIGH)
    else
        gpio.write(self.DIR,gpio.LOW)
    end
    -- Do Steps
    mytimer = tmr.create()
    for i=0,step do
        self:count(sens)
        self:check_fdc()
        gpio.write(self.STEP,gpio.LOW)
        tmr.delay(ddelay*1000)
        gpio.write(self.STEP,gpio.HIGH)
        tmr.delay(ddelay*1000)
        gpio.write(self.STEP,gpio.LOW)
    end
end

function Motor:set_pos(angle)
    if (angle<self.nbstep) then
        sens = 0
    else
        sens = 1
    end      
        self:set_step(sens,abs(angle-self.nbstep),10)
        print("Motor - set_angle done!",self.nbstep)
    end

function abs(number)
    if number>0 then 
        return number
    else 
        return -number
    end
end

function Motor:init_seq()
    print("Motor Init")
    sens = 1 -- First try in sens 1
    while(gpio.read(self.FDC) ~= gpio.LOW) do
        self:set_step(sens, 1, 10)
        if abs(self.nbstep)>self.COURSE then
            if(sens == 0) then
                break
            end
        end
    end
    sens = 0
    self.nbstep = 0
    print("Motor - FDC found")
    print(self.nbstep)
end


mt_plate = Motor:create(nil,7,8,500,0)
mt_lift = Motor:create(nil,2,3,4700,5)
   
function sequence()
    --mt_plate:init_seq()
    --mt_plate:set_pos(400)
    --mt_plate:set_pos(-400)
    print("sequence end")
end
        --set_up_down("down")

print("Hi HAL.LUA")
sequence()
