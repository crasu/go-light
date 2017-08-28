function init()
    local config = require("config")

    wifi.setmode(wifi.STATION)
    wifi.sta.config(config.SSID, config.PASS)

    tmr.alarm(1, 10*60*1000, tmr.ALARM_SINGLE, function()
        print("light sleep serial unstable ...")
        wifi.sleeptype(wifi.LIGHT_SLEEP)
    end)

    tmr.alarm(2, 5*1000, tmr.ALARM_SINGLE, function()
        print("ip addr:")
        print(wifi.sta.getip())
    end)

    gpio.mode(8, gpio.OUTPUT) -- red GPIO15
    gpio.mode(7, gpio.OUTPUT) -- yellow GPIO13
    gpio.mode(6, gpio.OUTPUT) -- green GPIO12
    gpio.mode(1, gpio.OUTPUT) -- pedestrian red GPIO5
    gpio.mode(2, gpio.OUTPUT) -- pedestrian green GPIO4
end

init()

srv=net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        local code, method, color = require("connection").handle(sck, payload)
        if code == 200 and method == "GET" and color then
            if color == "red" then
                gpio.write(8, gpio.HIGH)
                gpio.write(7, gpio.LOW)
                gpio.write(6, gpio.LOW)
                gpio.write(1, gpio.LOW)
                gpio.write(2, gpio.HIGH)
            elseif color == "yellow" then
                gpio.write(8, gpio.LOW)
                gpio.write(7, gpio.HIGH)
                gpio.write(6, gpio.LOW)
                gpio.write(1, gpio.HIGH)
                gpio.write(2, gpio.LOW)
            else
                gpio.write(8, gpio.LOW)
                gpio.write(7, gpio.LOW)
                gpio.write(6, gpio.HIGH)
                gpio.write(1, gpio.HIGH)
                gpio.write(2, gpio.LOW)
            end
        end
    end)
    conn:on("sent", function(sck) sck:close() end)
end)
