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

function Motor:init_seq(sens)
    print("Motor - fake init done")
end

function Motor:set_pos(angle, next_action)
    print("Motor set pos " .. angle)
    next_action()
end

function Motor:set_step(check, sens, step, ddelay)
    print("Make step")
end

function Motor:check_fdc()
    print("Check fdc")
    return true
end

function Motor:unset_fdc()
    print("Unset fdc")
end
