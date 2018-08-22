print("Application.lua")
dofile("hal.lua")
dofile("glass.lc")

function send_file(client, request, requested_file, next_action)
    local max_packet_size = 200
    if file.open(requested_file) then
        print(requested_file)
        local stat = file.stat(requested_file)
        local s = stat.size
        local already_sent = 0
        local function send_chunk(socket)
            if (already_sent >= s) then
                file.close()
                socket:close()
                next_action()
                return
            end
            local buf = ""
            if ((s - already_sent) < max_packet_size) then
                buf = file.read(s - already_sent)
                already_sent = s
            else
                buf = file.read(max_packet_size)
                already_sent = already_sent + max_packet_size
            end
            socket:send(buf, send_chunk)
        end
        send_chunk(client)
    end
end

function send_body(client, request, body, callback)
    send_file(client, request, body, callback)
end

function send_error(client, request)
    client:send("too many requests", function(socket)
        socket:close()
    end)
end

serving_cocktail = false
nb_connection = 0

function cocktail_done()
    serving_cocktail = false
end

function decrease_nb_connection()
    nb_connection = nb_connection - 1
    print("node heap", node.heap())
end

function receiver(client,request)
    print(nb_connection)
    if (nb_connection >= 10000) then
        send_error(client, request)
    else
        nb_connection = nb_connection + 1
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(.+)&*") do
                _GET[k] = v
            end
        end
        if (path=="/settings.html") then
            send_file(client, request, "settings.html", function()
                decrease_nb_connection()
            end)
            if(_GET.plate ~= nil) then
                    print("Set PLATE : ",_GET.plate)
                    set_plate(tonumber(_GET.plate)*4,function() print("plate")end)
            end
            if(_GET.lift ~= nil) then
                    print("Set LIFT:",_GET.lift)
                    set_lift(tonumber(_GET.lift),function() print("lift") end)
            end
            if(_GET.servo ~= nil) then
                    print("Set Servo:",_GET.servo)
                    set_servo(tonumber(_GET.servo),function() print("servo")end)
            end
            if(_GET.init ~= nil) then
                    init()
            end
            return
        else
            if (serving_cocktail) then
                send_body(client, request, "already_serving_body.html", decrease_nb_connection)
            end
        end
        cocktail = _GET.cocktail
        if cocktail ~= nil then
            print('try to make cocktail ' .. cocktail)
        else
            send_body(client, request, "default_body.html", decrease_nb_connection)
        end
        if (recipes[cocktail] ~= nil and not serving_cocktail) then
            serving_cocktail = true
            send_body(client, request, "acknowledge_service_body.html", decrease_nb_connection)
            make_cocktail(recipes[cocktail], give_soft, give_hard, go_home, cocktail_done)
        else
            if serving_cocktail then
                print("Already serving cocktail")
            else
            end
        end
    end
end

function http_server()
    local srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive",receiver)
    end)
end

http_server()
