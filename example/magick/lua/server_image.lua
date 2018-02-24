local sig, size, path, ext = ngx.var.sig, ngx.var.size, ngx.var.path, ngx.var.ext

local secret = "hello_world" -- signature secret key
local images_dir = "images/" -- where images come from
local cache_dir = "cache/" -- where images are cached

local function return_not_found(msg)
    ngx.status = ngx.HTTP_NOT_FOUND 
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "not found")
    ngx.exit(0)
end

local function calculate_signature(str)
    return ngx.encode_base64(ngx.hmac_sha1(secret, str))
      :gsub("[+/=]", {["+"] = "-", ["/"] = "_", ["="] = ","})
      :sub(1,12)
end 

if calculate_signature(size .. "/" .. path) ~= sig then  -- 和sig参数进行对比，进行鉴权校验
  return_not_found("invalid signature")
end

local source_fname = images_dir .. path

-- make sure the file exists 
local file = io.open(source_fname)

if not file then 
    return_not_found
end 

file:close()

local dest_fname = cache_dir .. ngx.md5(size .. "/" .. path) .. "." .. ext 

-- resize the image 
local magick = require("magick")
magick.thumb(source_fname, size, dest_fname) -- resize the image, then the new resized image is in cache 

ngx.exec(ngx.var.request_uri)