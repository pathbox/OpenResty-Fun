4个端口分别对应4个html 根目录

html/index81.html 内容 server name 8081
html/index81.html 内容 server name 8082
html/index83.html 内容 server name 8083
html/index84.html 内容 server name 8084
如何切换后端upstream

default_upstream 切换到 lua_upstream
# curl http://127.0.0.1/_switch_upstream?upstream=lua_upstream
127.0.0.1 change upstream from default_upstream to lua_upstream
lua_upstream 切换（还原default_upstream）到 default_upstream
curl http://127.0.0.1/_switch_upstream?upstream=default_upstream
127.0.0.1 change upstream from lua_upstream to default_upstream