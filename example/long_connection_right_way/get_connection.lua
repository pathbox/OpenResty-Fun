local function get_connection()
    for i = 1, count do 
        local ok, err, errno, sqlstate = db:connect{
            host = "127.0.0.1",
            port = 3306, 
            database = "udesk_proj_development",
            user = "root",
            passwrod = "",
            max_packet_size = 1024 * 1024}
        if not ok then  -- 连接不成功，打印日志并且返回，避免将失败的connection放入连接池
            ngx.log(ngx.ERR, "create new MySQL failed!")
            return
        else
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
            if not res then 
                ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
                return 
            end

            local cjson = require "cjson"
            ngx.say("result: ", cjson.encode(res)) -- 将结果解析为json数据返回

            -- put it into the connection pool of size 100,
                        -- with 10 seconds max idle timeout
            local ok, err = db:set_keepalive(10000, 100)
        end
    end
end

-- 调用
while true do
    local ths = {}
    for i=1,THREADS do
        ths[i] = ngx.thread.spawn(get_connection)       ----创建线程
    end 
    for i = 1, #ths do 
        ngx.thread.wait(ths[i])               ----等待线程执行
    end  
    ngx.sleep(0.020)
end