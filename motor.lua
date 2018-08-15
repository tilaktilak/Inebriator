
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

-- On prend des FDC tapped lorsque que le lift est proche du bas, du coup
-- on ne va pas exactement à la consigne d'angle
function Motor:check_fdc()
    if (gpio.read(self.FDC)==gpio.LOW) then
        self.nbstep = 0
        return true
    else
        return false
    end
end

function Motor:unset_fdc()
    while(gpio.read(self.FDC)==gpio.LOW) do
        self.set_step(1,1,1,self.speed)
    end
end

function abs(number)
    if number>0 then 
        return number
    else 
        return -number
    end
end

function Motor:set_step(check, sens, step, ddelay)
    if sens == 1 then
        gpio.write(self.DIR,gpio.HIGH)
    else
        gpio.write(self.DIR,gpio.LOW)
    end
    -- Do Steps
    for i=0,step do
        self:count(sens)
        if(check==1) then
            self:check_fdc()
        end
        gpio.write(self.STEP,gpio.LOW)
        tmr.delay(ddelay)
        gpio.write(self.STEP,gpio.HIGH)
        tmr.delay(ddelay)
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
