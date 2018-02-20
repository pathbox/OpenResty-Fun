wrk -c50 -t4 http://127.0.0.1:8081
Running 10s test @ http://127.0.0.1:8081
  4 threads and 50 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     2.38ms    1.23ms  29.08ms   90.26%
    Req/Sec     5.15k   776.66     7.09k    60.00%
  205276 requests in 10.04s, 37.58MB read
Requests/sec:  20451.93
Transfer/sec:      3.74MB


https://github.com/362228416/openresty-web-dev