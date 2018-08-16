
function set_servo(value, next_action)
    servo.value=value
    print("Servo.value,",servo.value)
    for i=0,10 do
        gpio.write(servo.pin, gpio.HIGH)
        tmr.delay(servo.value)
        gpio.write(servo.pin, gpio.LOW)
        tmr.delay(20000-servo.value)
    end
    next_action()
end


