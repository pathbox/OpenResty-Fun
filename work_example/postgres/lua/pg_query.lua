local json = require "cjson"

function test_query()
    local res = ngx.location.capture('/postgres',
        { args = { sql = "SELECT * FROM test" } }
    )

    local status = res.status 
    local body = json.decode(res.body)

    if status == 200 then 
        status = true 
    else 
        status = false 
    end

    return status, body 
end