if ngx.var.arg_user == "admin" and ngx.var.arg_password == "password" then
    return
else
    ngx.exit(ngx.HTTP_FORBIDDEN)
end