
function give_hard(position, dose, next_action)
    print('serve hard ' .. position .. ' ' .. dose)
    timer = tmr.create()
    timer:register(5000, tmr.ALARM_SINGLE, next_action)
    timer:start()
end

function give_soft(position, dose, next_action)
    print('serve soft ' .. position .. ' ' .. dose)
    timer = tmr.create()
    timer:register(5000, tmr.ALARM_SINGLE, next_action)
    timer:start()
end

function go_home()
    print("return to init position")
end
