local ups = ngx.req.get_uri_args()["upstream"]
if ups == nil or ups == "" then
  ngx.say("params upstream is nul 1")
  return nil
end

local host = ngx.var.http_host
local upstreams = ngx.shared.upstreams
local ups_src = upstreams:get(host)
ngx.say("Current upstream is: ", ups_src)
ngx.log(ngx.WARN, host, " change upstream from ", ups_src, " to ", ups)
local succ, err, forcible = upstreams:set(host, ups)
ngx.say(host, " change upstream from ", ups_src, " to ", ups)
