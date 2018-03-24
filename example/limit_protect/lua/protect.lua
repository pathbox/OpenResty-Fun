function busy(path)
    local file = io.open(path)
    if not file then return nil end 
    local content = file:read "*a"
    file:close()
    return content
end

-- 读取共享数据

local global = ngx.shared.global 
local key = "req_" .. os.time(os.date("!*t"))
local current = global:get("current") -- map结构是这样的 {current: {key: count}} 
local req, err = global:get(current)

-- 非同一秒请求，将用最新的key 替换老的current
-- 同时将数据初始化为 0
if key ~= current then 
    global:set("current", key)
    global:set(key, 0)
end

-- 如果当前请求超过300 则进行拦截，输出系统繁忙页面
if req > 300 then 
    ngx.say(busy("/tmp/busy.html"))
    ngx.exit(ngx.HTTP_OK)
end

-- 请求数 + 1
global:incr(key, 1, 0) 
