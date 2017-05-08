print("*** Starting in 5 secs ***")
tmr.alarm(0, 5000, 0, function()
   print("Executing ...")
   dofile("server.lua")
end)

