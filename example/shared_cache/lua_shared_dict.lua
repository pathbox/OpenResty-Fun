function get_from_cache(key)
    local cache_ngx = ngx.shared.my_cache 
    local value = cache_ngx:get(key)
    return value 
end

func set_to_cache(key, value, exptime)
    if not exptime then 
        exptime = 0 
    end

    local cache_ngx = ngx.shared.my_cache
    local succ, err, forcible = cache_ngx:set(key, value, exptime)
    return succ 
end

-- conf/nginx.conf
-- lua_shared_dict my_cache 128m;
-- or lua_shared_dict my_cache 1m;

-- lua_shared_dict is better than lua_lru_cache
-- 一个是 lua lru cache 提供的 API 比较少，现在只有 get 、 set 和 delete ，而 ngx shared dict 还可以 add 、 replace 、 incr 、 get_stale （在 key 过期时也可以返回之前的值）、 get_keys （获取所有 key ，虽然不推荐，但说不定你的业务需要呢）；第二个是内存的占用，由于 ngx shared dict 是 workers 之间共享的，所以在多 worker 的情况下，内存占用比较