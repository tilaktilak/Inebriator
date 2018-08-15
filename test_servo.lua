
function set_servo(value, next_action)
    servo.value=value
    print("Servo.value,",servo.value)
    next_action()
end
