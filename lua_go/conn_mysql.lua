luasql = require "luasql.mysql"

env = luasql.mysql()

conn = env:connect("udesk_proj_development", "root", "", "127.0.0.1", 3306)

conn:execute"SET NAMES UTF-8"

cur = conn:execute("select * from companies")

row = cur:fetch({}, "a")

while row do
  print(row)
  print(cur)

  var = string.format("%d %s\n", row.id, row.subdomain)

  print(var)
end

conn:close()
env:close()