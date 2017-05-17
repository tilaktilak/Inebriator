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

function abs(number)
    if number>0 then 
        return number
    else 
        return -number
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

function init()
    mt_plate:init_seq()
    mt_lift:init_seq()
    print("Initialization OK")
        --set_up_down("down")
end

function go_home()
    mt_plate.:set_pos(0)
    if mt_plate.nbstep > 0 then
    sens = 1
    else 
    sens = 0
    end
    while(mt_plate.nbstep < mt_plate.COURSE) do
        mt_plate:set_step(sens, 1, 10)
        if (gpio.read(mt_plate.FDC)==gpio.LOW) then
            self.nbstep = 0
            break
        end
    end
    while(gpio.read(mt_lift.FDC)==gpio.LOW) do
        mt_lift:set_step(1,1,10)
    end
        --self:set_step(sens,abs(angle-self.nbstep),10)

end

function give_hard(position,quantity)
    if(position==1) then angle=100 end
    if(position==2) then angle=200 end
    if(position==3) then angle=300 end
    if(position==4) then angle=400 end
    mt_plate:set_pos(angle)
    mt_lift:set_pos(4700);
    tmr.delay(quantity*1000)
    sleep(quantity)
    mt_lift:set_pos(0);
end

function give_soft()
    if(position==1) then angle=100 end
    if(position==2) then angle=200 end
    if(position==3) then angle=300 end
    if(position==4) then angle=400 end
    mt_plate:set_pos(angle)
    -- 0.1  = +90
    -- 0.75 = 0
    -- 0.05 = -90
    pwm.setup(4, 50000,0.1*1023)
    pwm.start(4)
    tmr.delay(quantity*1000)
    pwm.setup(4, 50000,0.1*1023)
    pwm.stop(4)

end

print("Hi HAL.LUA")
sequence()
