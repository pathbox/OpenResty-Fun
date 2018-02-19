local mysql = require "resty.mysql"
local db, err = mysql:new()

if not db then 
    ngx.say("failed to instantiate mysql: ", err)
    return
end

db:set_timeout(1000)  -- 1s

local ok, err, errno, sqlstate = db:connect{
    host = "127.0.0.1",
    port = 3306, 
    database = "udesk_proj_development",
    user = "root",
    passwrod = "",
    max_packet_size = 1024 * 1024}

if not ok then 
    ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
    return
end

ngx.say("connected to mysql")

res, err, errno, sqlstate = db:query("select * from users order by id asc", 10)

if not res then 
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return 
end

local cjson = require "cjson"
ngx.say("result: ", cjson.encode(res)) -- 将结果解析为json数据返回

-- put it into the connection pool of size 100,
            -- with 10 seconds max idle timeout
local ok, err = db:set_keepalive(10000, 100)

if not ok then 
    ngx.say("failed to set keepalive: ", err)
    return 
end 