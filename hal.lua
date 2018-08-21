function go_home(next_action)
    print("go home")
    set_pos_motor(mt_plate, 0, function()
        local sens = 0
        if mt_plate.nbstep > 0 then
            sens = 1
        end
        while(mt_plate.nbstep < mt_plate.COURSE) do
            set_step(mt_plate, 1, sens, 1, mt_plate.speed)
            local nbstep_reset = check_fdc(mt_plate)
            if (nbstep_reset) then
                break
            end
        end
        unset_fdc(mt_lift)
        next_action()
    end)
end

function give_hard(position, quantity, next_actions)
    print("serve hard " .. position .. " " .. quantity)
    local angle = 0
    if(position==1) then angle=410*8 end
    if(position==2) then angle=640*8 end
    if(position==3) then angle=880*8 end
    if(position==4) then angle=1100*8 end
    if(position==5) then angle=0*8 end
    if(position==6) then angle=0*8 end
    set_pos_motor(mt_lift, angle, function()
        set_pos_motor(mt_lift, 8400, function()
            local timer = tmr.create()
            timer:register(quantity*1000, tmr.ALARM_SINGLE, function()
                set_pos_motor(mt_lift, 0, next_actions)
            end)
            timer:start()
        end)
    end)
end

function set_plate(angle)
    set_pos_motor(mt_plate, angle)
end

function set_lift(angle)
    set_pos_motor(mt_lift, -angle)
end

function give_soft(position, quantity, next_actions)
    print("serve soft " .. position .. " " .. quantity)
    local angle = 0
    if(position==1) then angle=915*8 end
    if(position==2) then angle=1015*8 end
    if(position==3) then angle=0*8 end
    if(position==4) then angle=0*8 end
    print("move plate")
    set_pos_motor(mt_plate, angle, function()
        print("trigger servo")
        set_servo(1800, function()
            print("wait")
            local timer = tmr.create()
            timer:register(quantity*1000, tmr.ALARM_SINGLE, function()
                print("down servo")
                set_servo(1000, next_actions)
            end)
            timer:start()
        end)
    end)
    -- 0.1  = +90
    -- 0.75 = 0
    -- 0.05 = -90
    --pwm.setup(4, 50000,0.1*1023)
    --pwm.start(4)
    --tmr.delay(quantity*1000000)
    --pwm.setup(4, 50000,0.05*1023)
    --pwm.stop(4)
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

function init()
    -- mt_lift and mt_plate are global
    -- defined at the end of this file
    init_seq(mt_plate)
    init_seq(mt_lift, 0)
    print("Initialization OK")
end

print("HAL.LUA : Initialization start")

print("Init servo")
dofile("servo.lua")
servo = {}
servo.pin = 4 --this is GPIO2
servo.value = 1000
servo.id = "servo"
gpio.mode(servo.pin,gpio.OUTPUT)
gpio.write(servo.pin,gpio.LOW)

print("Init motors")
dofile("motor.lua")
print("Init motor plate")
mt_plate = create_motor()
init_motor(mt_plate,7,8,500*8,0,50*10)

print("Init motor lift")
mt_lift = create_motor()
init_motor(mt_lift,2,12,8400,5,1)

print("Global init")
init()
set_servo(1000, function()
    print("global init done")
end)
print("HAL.LUA : Initialization OK")
