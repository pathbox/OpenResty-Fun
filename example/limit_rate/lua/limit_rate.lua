local cjson = require "cjson"
local uri = ngx.var.uri 
-- 从 body中 读取 limit_size 

ngx.req.read_body()
local data = ngx.req.get_body_data()
if data then 
    local content = cjson.decode(data) -- 反序列化为table json数据
    if content["limit_size"] then
        local limit_size = content["limit_size"] .. "K"
        ngx.log(ngx.ERR, "------get limit size from req body is: ", limit_size)
        ngx.log(ngx.ERR, "------request method: ", ngx.var.request_method)

        ngx.var.limit_rate = limit_size
    end
else
    ngx.log(ngx.INFO, "request params is not right")
end