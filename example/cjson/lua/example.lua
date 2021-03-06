local cjson = require "cjson"

-- 先定义一个json字符串
local json_str = '{"name": "Bruce.Lin", "age": 25}'
-- 这里把它转成对象，然后输出属性
local json = cjson.decode(json_str)  -- json 对象 用于具体操作json对象
ngx.say("Name = " .. json['name'] .. ", Age = " .. tostring(json['age'])) -- 这里需要把25转成字符串，才能进行字符串拼接

-- 输出 Name = Bruce.Lin, Age = 25

ngx.say('<br/>') -- 换行

-- 接下来我们再把json对象转成json字符串
local json_str2 = cjson.encode(json) -- json字符串 用于显示渲染
ngx.say(json_str2)

-- 输出{"name":"Bruce.Lin","age":25}

ngx.say('<br/>') -- 换行

local obj = {
	ret = 200,
	msg = "login success"
}

ngx.say(cjson.encode(obj)) -- 把一个table 对象 序列化为json 字符串

ngx.say('<br/>') -- 换行

local obj2 = {}

obj2['ret'] = 200
obj2['msg'] = "login fails"

ngx.say(cjson.encode(obj2))