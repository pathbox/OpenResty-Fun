local json = require("cjson")
local str  = [[ {"key":"value"} ]]

local t    = json.decode(str)
print(t)
print(type(t))
print(t["key"])
-- ngx.say(" --> ", type(t))

-- ... do the other things
-- ngx.say("all fine")