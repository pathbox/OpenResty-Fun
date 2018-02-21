local balancer = require "ngx.balancer"
local upstream = require "ngx.upstream"

local upstream_name = 'backend'

local srvs = upstream.get_servers(upstream_name)

function get_server()
    local cache = ngx.shared.cache 
    local key = "req_index"
    local index = cache:get(key)

    if index == nil or index > #srvs then 
        index = 1 
        cache:set(key, index)
    end
    cache:incr(key, 1)
    return index 
end

function is_down(server) -- srv if down
    local down = false 
    local perrs = upstream.get_primary_peers(upstream_name)
    for i=1, #peers do 
        local peer = peers[i]
        if server == peer.name and peer.down == true then 
            down = true 
        end
    end
    return down 
end

local route = ngx.var.cookie_route 

local server 

if route then 
    for k, v in pairs(srvs) do 
        if ngx.md5(v.name) == route then  -- cookie route md5(is srv.name) 
            server = v.addr 
        end
    end
    if is_down(server) then
        route = nil
    end
end

if not route then
    for i = 1, #srvs do
        if not server or is_down(server) then
            server = srvs[get_server()].addr
        end
    end
    ngx.header["Set-Cookie"] = 'route=' .. ngx.md5(server) .. '; path=/;'
end

local index = string.find(server, ':')
local host = string.sub(server, 1, index - 1)
local port = string.sub(server, index + 1)
balancer.set_current_peer(host, tonumber(port))
