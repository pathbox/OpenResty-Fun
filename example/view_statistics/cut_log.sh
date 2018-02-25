_prefix="/path/to/nginx"
time=`date +%Y%m%d%H`

mv ${_prefix}/logs/ma.log ${_prefix}/logs/ma/ma-${time}.log
kill -USR1 `cat ${_prefix}/logs/nginx.pid`



# 然后再/etc/crontab里加入一行：

# 59  *  *  *  * root /path/to/directory/cut_log.sh