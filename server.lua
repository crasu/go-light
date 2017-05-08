function init()
    local config = require("config")

    wifi.setmode(wifi.STATION)
    wifi.sta.config(config.SSID, config.PASS)

    tmr.alarm(1, 10*60*1000, tmr.ALARM_SINGLE, function()
        print("light sleep serial unstable ...")
        wifi.sleeptype(wifi.LIGHT_SLEEP)
        print(wifi.sta.getip())
    end)

    gpio.mode(15, gpio.Pin.OUT) -- red
    gpio.mode(13, gpio.Pin.OUT) -- yellow 
    gpio.mode(12, gpio.Pin.OUT) -- green
end

init()

srv=net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        local code, method, color = require("connection").handle(sck, payload)
        if code == 200 and method == "GET" and color then
            if color == "red" then
                gpio.write(15, gpio.HIGH)
                gpio.write(13, gpio.LOW)
                gpio.write(12, gpio.LOW)
            elseif color == "yellow" then
                gpio.write(15, gpio.LOW)
                gpio.write(13, gpio.HIGH)
                gpio.write(12, gpio.LOW)
            else
                gpio.write(15, gpio.LOW)
                gpio.write(13, gpio.LOW)
                gpio.write(12, gpio.HIGH)
            end
        end
    end)
    conn:on("sent", function(sck) sck:close() end)
end)

