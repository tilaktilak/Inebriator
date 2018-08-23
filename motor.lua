
function create_motor()
    return {
        STEP = 0,
        DIR = 0,
        COURSE = 0,
        FDC = 0,
        nbstep = 0,
        angle = 0,
        speed = 0
    }
end

function init_motor(motor, STEP,DIR,COURSE,FDC,SPEED)
    motor.STEP = STEP
    motor.DIR = DIR
    motor.FDC = FDC
    motor.COURSE = COURSE
    motor.nbstep = 0
    motor.angle = 0
    motor.speed = SPEED
    print("step ",STEP)
    print("dir ",DIR)
    print("course ",COURSE)
    print("fdc ",FDC)
    gpio.mode(FDC, gpio.INPUT)
    gpio.mode(STEP, gpio.OUTPUT) -- STEP
    gpio.write(STEP, gpio.LOW)
    gpio.mode(DIR,  gpio.OUTPUT) -- DIR
end

function motor_count(motor, sens)
    if sens==1 then
        motor.nbstep = motor.nbstep + 1
    else
        motor.nbstep = motor.nbstep - 1
    end
end

-- On prend des FDC tapped lorsque que le lift est proche du bas, du coup
-- on ne va pas exactement à la consigne d'angle
function check_fdc_motor(motor)
    if (gpio.read(motor.FDC)==gpio.LOW) then
        motor.nbstep = 0
        return true
    else
        return false
    end
end

function unset_fdc(motor)
    while(gpio.read(motor.FDC)==gpio.LOW) do
        set_step(motor,1,1,1,motor.speed)
    end
end

function abs(number)
    if number>0 then
        return number
    else
        return -number
    end
end

function set_step(motor, check, sens, step, ddelay)
    if sens == 1 then
        gpio.write(motor.DIR,gpio.HIGH)
    else
        gpio.write(motor.DIR,gpio.LOW)
    end
    -- Do Steps
    for i=0,step do
        motor_count(motor, sens)
        if(check==1) then
            check_fdc_motor(motor)
        end
        gpio.write(motor.STEP,gpio.LOW)
        tmr.delay(ddelay)
        gpio.write(motor.STEP,gpio.HIGH)
        tmr.delay(ddelay)
    end
end

function set_pos_motor(motor, angle, next_action)
    print("Set pos motor angle:",angle)
    print("Set pos motor nbstep:",motor.nbstep)
    if (angle < motor.nbstep) then
        sens = 0
    else
        sens = 1
    end
    CHECK = 1
    check_fdc_motor(motor)
    if(motor.nbstep == 0) then
        CHECK = 0 -- We are at FDC, no check
    end
    set_step(motor, CHECK,sens,abs(angle-motor.nbstep),motor.speed)
    print("Motor - set_angle done!",motor.nbstep)
    next_action()
end

function init_seq(motor, sens)
    print("Motor Init")
    local sens = sens or 1 -- First try in sens 1
    motor.nbstep = 0
    while(gpio.read(motor.FDC) ~= gpio.LOW) do
    --print(sens)
        set_step(motor, 1,sens, 1, motor.speed)
        if abs(motor.nbstep)>motor.COURSE then
            if(sens == 0) then
                break
            end
            sens = 0
        end
    end
    sens = 0
    motor.nbstep = 0
    print("Motor - FDC found")
    print(motor.nbstep)
end
