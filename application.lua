print("Application.lua")
--dofile("hal.lua")
--dofile("glass.lua")

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
    if (path=="/settings.html") then
        if file.open("settings.html") then
          local s = file.stat("settings.html")
          buf = file.read(s.size)
          file.close()
        end
    else
        print("Open index.html")            
        --buf = "TEST"
        if file.open("index.html") then
            function send(file)
                local buf = file.read()
                if(buf == nil)then
                    print("close send")
                    file.close()
                    return
                else
                    print("send buff",buf)
                    client:send(buf)
                    send(file)
                end
            end
            send(file)
        end
        --  local s = file.stat("index.html")
        --  buf = file.read(s.size)
        --  file.close()
        --end
    end
    local _on,_off = "",""
    if(_GET.cocktail == "cocktail1") then
        make_cocktail(R_Whiskey_Coca)
    end
    if(_GET.cocktail == "cocktail2") then
        make_cocktail(R_Cuba_Libre)
    end
    if(_GET.cocktail == "cocktail3") then
        make_cocktail(R_Punch)
    end
    if(_GET.cocktail == "cocktail4") then
        make_cocktail(R_Tequila_Sunrise)
    end
    if(_GET.cocktail == "cocktail5") then
        make_cocktail(R_Sex_On_The_Beach)
    end
    if(_GET.cocktail == "cocktail6") then
        make_cocktail(R_Punch_Planteur)
    end
    if(_GET.cocktail == "cocktail7") then
        make_cocktail(R_After_Glow)
    end
    if(_GET.cocktail == "cocktail8") then
        make_cocktail(R_Orange)
    end
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
    --client:send(buf)
    --collectgarbage()
end

function http_server()
    local srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive",receiver)
        conn:on("sent", function (conn) conn:close() end)
    end)
end

http_server()
