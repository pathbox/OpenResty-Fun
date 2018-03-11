-- https://github.com/openresty/lua-resty-lock#for-cache-locks
-- # you may want to change the dictionary size for your cases.
--     lua_shared_dict my_cache 10m;
--     lua_shared_dict my_locks 1m;

local resty_lock = require "resty.lock"
local cache = ngx.shared.my_cache 

-- step 1:
local val, err = cache:get(key)  -- 从缓存中获取值
if val then 
    ngx.say("result: ", val)
    return
end

if err then 
    return fail("failed to get key from shm: ", err)
end

-- cache miss! 
-- step 2:
local lock, err = resty_lock:new("my_locks")  -- 新建 resty_lock 锁
if not lock then 
    return fail("failed to create lock: ", err)
end

local elapsed, err = lock:lock(key) -- 对 key 加锁
if not elapsed then 
    return fail("failed to acquire the lock: ", err)
end

-- lock successfully acquired!

-- step 3:
-- someone might have already put the value into the cache
-- so we check it here again:
val, err = cache:get(key)
if val then 
    local ok, err = lock:unlock()  -- 解锁
    if not ok then 
        return fail("failed to unlock: ", err)
    end

    ngx.say("result: ", val)
    return 
end

--step 4:
local val = fetch_redis(key)  -- 从(数据库)redis 中查找key
  if not val then 
    local ok, err = lock:unlock() -- 没有获取到值，解锁
    if not ok then
        return fail("failed to unlock: ", err)
    end

    -- FIXME: we should handle the backend miss more carefully
    -- here, like inserting a stub value into the cache.

    ngx.say("no value found")
    return
end

-- update the shm cache with the newly fetched value
local ok, err = cache:set(key, val, 1) -- 从redis中获取到val，对cache 进行更新
if not ok then
    local ok, err = lock:unlock() -- 更新出错 解锁
    if not ok then
        return fail("failed to unlock: ", err)
    end

    return fail("failed to update shm cache: ", err)
end

local ok, err = lock:unlock() -- 最后 解锁
if not ok then
    return fail("failed to unlock: ", err)
end

-- 流程注释： 从cache中取值，取到值返回，没有取到，使用resty_lock 加锁， 从redis中重新获取值，获取成功，更新cache中的值，最后解锁
-- 使用resty_lock 保证在更新缓存的时候，只有一个操作在进行，更新完成之后，cache中就有值了，之后的访问就会从cache中获取，而不会再进行数据库查询
-- 这是一种处理 缓存（雪崩）失效的方法，对缓存失效后的第一次更新缓存操作加锁，更新缓存，缓存重新拥有值，之后的查询将从缓存中获取，而不会查询数据库

-- 简单来说就是缓存重建时，当多个客户端对同一个缓存数据发起请求时，会在客户端采用加锁等待的方式，对同一个Cache的重建需要获取到相应的锁才行，
-- 只有一个客户端能拿到锁，并且只有拿到锁的客户端才能访问数据库重建缓存，其它的客户端都需要等待这个拿到锁的客户端重建好缓存后直接读缓存，
-- 其结果是对同一个缓存数据，只进行一次数据库重建访问。但是如果访问分散比较严重，还是会瞬间对数据库造成非常大的压力。

