print("Application.lua")
dofile("hal.lua")
dofile("glass.lua")

function function1()
        print("in funciton 1 Running")
end
function1()

function receiver(client,request)
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
    buf = buf.."Hello There"
   -- if (path=="/settings.html") then
   --     if file.open("settings.html") then
   --       s = file.stat("settings.html")
   --       buf = file.read(s.size)
   --       file.close()
   --     end
   -- else
   --     if file.open("index.html") then
   --       s = file.stat("index.html")
   --       buf = file.read(s.size)
   --       file.close()
   --     end
   -- end
    local _on,_off = "",""
    if(_GET.cocktail == "cocktail1") then
        print("Will do coctail".._GET.cocktail)
        make_cocktail(R_Whiskey_Coca)
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
    client:send(buf)
    buf = nil
end

function http_server()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive",receiver)
        conn:on("sent", function (conn) conn:close() end)
    end)
end


http_server()
