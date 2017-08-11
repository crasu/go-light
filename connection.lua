local M, module = {}, ...

function validate(c)
    return c == "green" or c == "yellow" or c == "red"
end

function M.handle(client, request)
    package.loaded[module]=nil

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

    local color = string.match(path,"/(%w+)")
    
    if color then
        color = string.lower(color)
    else
        color = ""
    end

    if method == "GET" and validate(color) then
        local buf = "HTTP/1.1 200 OK\n\n"
        buf = buf .. "Setting light to " .. color .. "\n"

        client:send(buf)
        return 200, method, color
    elseif method == "GET" and path == "/" then
        local buf = "HTTP/1.1 200 OK\n\n"
        buf = buf .. "nodemcu ok\n" 

        client:send(buf)
        return 200, method, color
    else
        local buf = "HTTP/1.1 400 Bad Request\n\n"
        buf = buf .. "cannot process request: " .. method .. " " .. path .. "\n"

        client:send(buf)
        return 400, method, color
    end
end

return M
