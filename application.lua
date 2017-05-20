print("Application.lua")
dofile("hal.lua")
loadfile("glass.lua")

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
        for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
            _GET[k] = v
        end
    end
    --buf = buf.."<h1> Hello, Inebriator.</h1><form src=\"/\">Turn PIN1 <select name=\"pin\" onchange=\"form.submit()\">"
    if file.open("index.html") then
        s = file.stat("index.html")
      --print(file.read())
      buf = buf..file.read(s.size)
      print(buf)
      file.close()
    end
    local _on,_off = "",""
    if(_GET.pin == "Cuba")then
          _on = " selected=true"
          gpio.write(1, gpio.HIGH)
          print("Whiskey Coca")
    elseif(_GET.pin == "Whiskey_Coca")then
          _off = " selected=\"true\""
          gpio.write(1, gpio.LOW)
          print("Cuba Libre")
    end
    --buf = buf.."<option".._on..">Cuba_Libre</opton><option".._off..">Whiskey_Coca</option></select></form>"
    client:send(buf)
end

function http_server()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive",receiver)
        conn:on("sent", function (c) c:close() end)
    end)
end


http_server()
