local req = require "req"
local cjson = require "cjson"

local args = req.getArgs()

-- GET
local res = ngx.location.capture('/user/login', {method = ngx.HTTP_GET, args = args})

-- POST
local res = ngx.location.capture('/user/login', {method = ngx.HTTP_POST, body = ngx.encode_args(args)})

-- print(res.status) -- 状态码

if res.status == 200 then 
    local ret = cjson.decode(res.body) -- json 对象
    ret['from'] = 'local'
    ngx.say(cjson.encode(ret)) -- json 字符串
else
    print(res.body)
    ngx.say('{"ret": false, "from": "local"}')
end 

-- 上面的请求方式会带上本地请求的请求头、cookie、以及请求参数
