local req = require "param"
local args = req.getArgs()

print(args) 

local name = args['name']

if name == nil or name == "" then
    name = "guest"
end

ngx.say("<p> hello " .. name .. "!</p>")
