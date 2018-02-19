local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000)

local ok, err = red:connect("127.0.0.1:6379")
if not ok then
    ngx.say("failed to connect: ", err)
end

ok, err = red:set("cat", "an animal")

if not ok then 
    ngx.say("fauled to set cat: ", err)
end

ngx.say("set result: ", ok)

local ok, err = red:set_keepalive(10000, 100)

if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end