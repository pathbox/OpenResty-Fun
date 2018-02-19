local req = require "req"
local cjson = require "cjson"
local http = require "resty.http"

local args = req.getArgs()

-- GET
-- local res = ngx.location.capture('/user/login', {method = ngx.HTTP_GET, args = args})

-- POST
-- local res = ngx.location.capture('/user/login', {method = ngx.HTTP_POST, body = ngx.encode_args(args)})

-- http
local httpc = http.new() -- http client
lcoal res = httpc:request_uri("http://127.0.0.1:8080/user/login",{
    nmethod = "POST",
    body = ngx.encode_args(args),
    headers = {
        ["Accept"] = "application/json",
        ["Accept-Encoding"] = "utf-8",
        ["Cookie"] = ngx.req.get_headers()['Cookie'],
        ["Content-Type"] = "application/json",
    }
})

httpc:set_keepalive(60)

print(res.status) -- 状态码

if res.status == 200 then 
    local ret = cjson.decode(res.body)
    ret['from'] = 'local'
    ngx.say(cjson.encode(ret)) -- 返回json数据，就是返回json 字符串
else
    print(res.body)
	ngx.say('{"ret": false, "from": "local"}')
end

