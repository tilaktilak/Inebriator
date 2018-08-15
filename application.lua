print("Application.lua")
--dofile("hal.lua")
dofile("test_hal.lua")
dofile("glass.lua")

function send_file(client, request, requested_file, next_action)
    local max_packet_size = 500
    if file.open(requested_file) then
        local stat = file.stat(requested_file)
        local s = stat.size
        local already_sent = 0
        function send_chunk(socket)
            if (already_sent >= s) then
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

function send_files(client, request, requested_contents)
    local function make_send_file_action(file_to_send, next_action)
        local function send_file_action()
            send_file(client, request, file_to_send, next_action)
        end
        return send_file_action
    end
    local function after_send()
        client:close()
        return
    end
    local function pile_up_send(send_actions)
        if (table_length(requested_contents) == 0) then
            return send_actions
        end
        file_to_send = table.remove(requested_contents)
        print(file_to_send)
        return pile_up_send(make_send_file_action(file_to_send, send_actions))
    end
    action = pile_up_send(after_send)
    action()
end

serving_cocktail = false

function cocktail_done()
    serving_cocktail = false
end

function receiver(client,request)
    print("Open index.html")            
    local buf = ""
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
    files_to_send = {}
    table.insert(files_to_send, "header.html")
    if (path=="/settings.html") then
        table.insert(files_to_send, "settings.html")
    else
        if (serving_cocktail) then
            table.insert(files_to_send, "already_serving_body.html")
        end
    end
    cocktail = _GET.cocktail
    if cocktail ~= nil then
        print('try to make cocktail ' .. cocktail)
    else
        table.insert(files_to_send, "default_body.html")
    end
    if (recipes[cocktail] ~= nil and not serving_cocktail) then
        serving_cocktail = true
        table.insert(files_to_send, "acknowledge_service_body.html")
        make_cocktail(recipes[cocktail], give_soft, give_hard, go_home, cocktail_done)
    else
        if serving_cocktail then
            print("Already serving cocktail")
        else
            print("Not a coktail, maybe another order...")
        end
    end
    table.insert(files_to_send, "footer.html")
    send_files(client, request, files_to_send)
    -- if(_GET.cocktail == "cocktail1") then
    --     make_cocktail(R_Whiskey_Coca)
    -- end
    -- if(_GET.cocktail == "cocktail2") then
    --     make_cocktail(R_Cuba_Libre)
    -- end
    -- if(_GET.cocktail == "cocktail3") then
    --     make_cocktail(R_Punch)
    -- end
    -- if(_GET.cocktail == "cocktail4") then
    --     make_cocktail(R_Tequila_Sunrise)
    -- end
    -- if(_GET.cocktail == "cocktail5") then
    --     make_cocktail(R_Sex_On_The_Beach)
    -- end
    -- if(_GET.cocktail == "cocktail6") then
    --     make_cocktail(R_Punch_Planteur)
    -- end
    -- if(_GET.cocktail == "cocktail7") then
    --     make_cocktail(R_After_Glow)
    -- end
    -- if(_GET.cocktail == "cocktail8") then
    --     make_cocktail(R_Orange)
    -- end
    if(_GET.plate ~= nil) then
            print("Set PLATE : ",_GET.plate)
            set_plate(tonumber(_GET.plate)*8)
    end
    if(_GET.lift ~= nil) then
            print("Set LIFT:",_GET.lift)
            set_lift(tonumber(_GET.lift))
    end
    if(_GET.servo ~= nil) then
            print("Set Servo:",_GET.servo)
            set_servo(tonumber(_GET.servo))
    end 
    if(_GET.init ~= nil) then
            init()
    end
end

function http_server()
    local srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive",receiver)
    end)
end

http_server()
