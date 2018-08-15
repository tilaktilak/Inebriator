
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


