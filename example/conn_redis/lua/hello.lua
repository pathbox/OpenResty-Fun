local cjson = require "cjson"
local redis = require "auth.redis"
local req = require "param"

local args = req.getArgs()
local key = args['key']

if key == nil or key == "" then
	key = "foo"
end

-- 下面的代码跟官方给的基本类似，只是简化了初始化代码，已经关闭的细节，我记得网上看到过一个  是修改官网的代码实现，我不太喜欢修改库的源码，除非万不得已，所以尽量简单的实现
local red = redis:new()
local value = red:get(key)
red:close()

local data = {
	ret = 200,
	data = value
}
ngx.say(cjson.encode(data))