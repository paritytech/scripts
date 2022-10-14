Docker image to push and check benchmark results

Long term storage metrics is done with Thanos now
https://github.com/paritytech/devops/wiki/DevOps-Internal%3A-Thanos

### Thanos Query Frontend https://thanos.parity-mgmt.parity.io/

## check_bench_result.py

The script takes an output file of `carg bench`, compares current result with the 
latest result and creates a github issue if the threshold is exceeded.



<details>
<summary> cat output.txt</summary>

```
Gnuplot not found, using plotters backend
test jsonrpsee_types_array_params_baseline ... bench:         310 ns/iter (+/- 0)

test jsonrpsee_types_array_params ... bench:         447 ns/iter (+/- 4)

test jsonrpsee_types_object_params_baseline ... bench:         313 ns/iter (+/- 4)

test jsonrpsee_types_object_params ... bench:         454 ns/iter (+/- 3)

test sync/http_custom_headers_round_trip/0kb ... bench:      168494 ns/iter (+/- 1862)

test sync/http_custom_headers_round_trip/1kb ... bench:      169180 ns/iter (+/- 9196)

test sync/http_custom_headers_round_trip/5kb ... bench:      173484 ns/iter (+/- 1503)

test sync/http_custom_headers_round_trip/25kb ... bench:      200479 ns/iter (+/- 11267)

test sync/http_custom_headers_round_trip/100kb ... bench:      357460 ns/iter (+/- 9856)

test sync/http_concurrent_conn_calls/fast_call/2 ... bench:      448057 ns/iter (+/- 11749)
test sync/http_concurrent_conn_calls/fast_call/4 ... bench:      647270 ns/iter (+/- 19855)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 6.6s, enable flat sampling, or reduce sample count to 60.
test sync/http_concurrent_conn_calls/fast_call/8 ... bench:     1313766 ns/iter (+/- 49675)

test sync/http_round_trip/fast_call ... bench:      168416 ns/iter (+/- 5727)

test sync/http_round_trip/memory_intense ... bench:    11217561 ns/iter (+/- 628609)


Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 6.3s, enable flat sampling, or reduce sample count to 60.
test sync/http_round_trip/slow_call ... bench:     1242716 ns/iter (+/- 6565)

test sync/http_batch_requests/fast_call/2 ... bench:      183787 ns/iter (+/- 4072)
test sync/http_batch_requests/fast_call/5 ... bench:      212384 ns/iter (+/- 6337)
test sync/http_batch_requests/fast_call/10 ... bench:      259066 ns/iter (+/- 4076)
test sync/http_batch_requests/fast_call/50 ... bench:      631433 ns/iter (+/- 72397)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 5.5s, enable flat sampling, or reduce sample count to 60.
test sync/http_batch_requests/fast_call/100 ... bench:     1110913 ns/iter (+/- 13165)

test sync/ws_custom_headers_handshake/0kb ... bench:      271954 ns/iter (+/- 32278)
test sync/ws_custom_headers_handshake/1kb ... bench:      269860 ns/iter (+/- 28035)
test sync/ws_custom_headers_handshake/2kb ... bench:      292654 ns/iter (+/- 42563)
test sync/ws_custom_headers_handshake/4kb ... bench:      279364 ns/iter (+/- 15556)


Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 5.5s, enable flat sampling, or reduce sample count to 60.
test sync/ws_concurrent_conn_calls/fast_call/2 ... bench:      630050 ns/iter (+/- 41424)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 9.1s, enable flat sampling, or reduce sample count to 50.
test sync/ws_concurrent_conn_calls/fast_call/4 ... bench:      591826 ns/iter (+/- 41035)
test sync/ws_concurrent_conn_calls/fast_call/8 ... bench:      763169 ns/iter (+/- 65741)

test sync/ws_round_trip/fast_call ... bench:      124336 ns/iter (+/- 586)

test sync/ws_round_trip/memory_intense ... bench:     6193807 ns/iter (+/- 76137)


Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 6.0s, enable flat sampling, or reduce sample count to 60.
test sync/ws_round_trip/slow_call ... bench:     1196659 ns/iter (+/- 14104)

test sync/ws_batch_requests/fast_call/2 ... bench:      149782 ns/iter (+/- 926)
test sync/ws_batch_requests/fast_call/5 ... bench:      182405 ns/iter (+/- 4952)
test sync/ws_batch_requests/fast_call/10 ... bench:      233836 ns/iter (+/- 2619)
test sync/ws_batch_requests/fast_call/50 ... bench:      641788 ns/iter (+/- 16275)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 5.7s, enable flat sampling, or reduce sample count to 60.
test sync/ws_batch_requests/fast_call/100 ... bench:     1140227 ns/iter (+/- 49610)


Warning: Unable to complete 100 samples in 10.0s. You may wish to increase target time to 13.4s, enable flat sampling, or reduce sample count to 60.
test sync/http_concurrent_conn_calls/fast_call/16 ... bench:     2661736 ns/iter (+/- 30632)
test sync/http_concurrent_conn_calls/fast_call/32 ... bench:     5148522 ns/iter (+/- 237067)
test sync/http_concurrent_conn_calls/fast_call/64 ... bench:     9822951 ns/iter (+/- 481771)

test sync/ws_concurrent_conn_calls/fast_call/16 ... bench:     1447823 ns/iter (+/- 83497)
test sync/ws_concurrent_conn_calls/fast_call/32 ... bench:     2672256 ns/iter (+/- 92009)
test sync/ws_concurrent_conn_calls/fast_call/64 ... bench:     5167205 ns/iter (+/- 105101)

test sync/ws_concurrent_conn_subs/16 ... bench:     2634860 ns/iter (+/- 56929)
test sync/ws_concurrent_conn_subs/32 ... bench:     5083903 ns/iter (+/- 109744)
test sync/ws_concurrent_conn_subs/64 ... bench:     9773434 ns/iter (+/- 175733)


Warning: Unable to complete 100 samples in 60.0s. You may wish to increase target time to 88.5s, enable flat sampling, or reduce sample count to 50.
test sync/http_concurrent_conn_calls/fast_call/128 ... bench:    17333057 ns/iter (+/- 935746)
test sync/http_concurrent_conn_calls/fast_call/256 ... bench:    29345874 ns/iter (+/- 1231844)
test sync/http_concurrent_conn_calls/fast_call/512 ... bench:    51201527 ns/iter (+/- 3148005)
test sync/http_concurrent_conn_calls/fast_call/1024 ... bench:    95090333 ns/iter (+/- 5700833)

test sync/ws_concurrent_conn_calls/fast_call/128 ... bench:    10048090 ns/iter (+/- 122123)
test sync/ws_concurrent_conn_calls/fast_call/256 ... bench:    18334707 ns/iter (+/- 332606)
test sync/ws_concurrent_conn_calls/fast_call/512 ... bench:    30463108 ns/iter (+/- 539463)
test sync/ws_concurrent_conn_calls/fast_call/1024 ... bench:    48806972 ns/iter (+/- 732477)

test sync/ws_concurrent_conn_subs/128 ... bench:    17056670 ns/iter (+/- 171992)
test sync/ws_concurrent_conn_subs/256 ... bench:    27835525 ns/iter (+/- 480825)
test sync/ws_concurrent_conn_subs/512 ... bench:    46950161 ns/iter (+/- 629811)
test sync/ws_concurrent_conn_subs/1024 ... bench:    78467296 ns/iter (+/- 774940)

test async/http_custom_headers_round_trip/0kb ... bench:      189791 ns/iter (+/- 2318)

test async/http_custom_headers_round_trip/1kb ... bench:      190746 ns/iter (+/- 3059)

test async/http_custom_headers_round_trip/5kb ... bench:      196181 ns/iter (+/- 1230)

test async/http_custom_headers_round_trip/25kb ... bench:      222459 ns/iter (+/- 1911)

test async/http_custom_headers_round_trip/100kb ... bench:      381540 ns/iter (+/- 7448)

test async/http_concurrent_conn_calls/fast_call/2 ... bench:      480817 ns/iter (+/- 12448)
test async/http_concurrent_conn_calls/fast_call/4 ... bench:      701661 ns/iter (+/- 14061)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 7.0s, enable flat sampling, or reduce sample count to 50.
test async/http_concurrent_conn_calls/fast_call/8 ... bench:     1401057 ns/iter (+/- 32206)

test async/http_round_trip/fast_call ... bench:      190215 ns/iter (+/- 19140)

test async/http_round_trip/memory_intense ... bench:     7575951 ns/iter (+/- 661458)


Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 6.4s, enable flat sampling, or reduce sample count to 60.
test async/http_round_trip/slow_call ... bench:     1263450 ns/iter (+/- 8226)

test async/http_batch_requests/fast_call/2 ... bench:      204390 ns/iter (+/- 1486)
test async/http_batch_requests/fast_call/5 ... bench:      234345 ns/iter (+/- 1573)
test async/http_batch_requests/fast_call/10 ... bench:      280054 ns/iter (+/- 15930)
test async/http_batch_requests/fast_call/50 ... bench:      649166 ns/iter (+/- 27807)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 5.4s, enable flat sampling, or reduce sample count to 60.
test async/http_batch_requests/fast_call/100 ... bench:     1117989 ns/iter (+/- 138391)

test async/ws_custom_headers_handshake/0kb ... bench:      295675 ns/iter (+/- 18832)
test async/ws_custom_headers_handshake/1kb ... bench:      296993 ns/iter (+/- 15864)
test async/ws_custom_headers_handshake/2kb ... bench:      301068 ns/iter (+/- 12197)
test async/ws_custom_headers_handshake/4kb ... bench:      301115 ns/iter (+/- 7918)


Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 6.1s, enable flat sampling, or reduce sample count to 60.
test async/ws_concurrent_conn_calls/fast_call/2 ... bench:      633870 ns/iter (+/- 9509)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 9.3s, enable flat sampling, or reduce sample count to 50.
test async/ws_concurrent_conn_calls/fast_call/4 ... bench:      687565 ns/iter (+/- 12632)
test async/ws_concurrent_conn_calls/fast_call/8 ... bench:      854964 ns/iter (+/- 19666)

test async/ws_round_trip/fast_call ... bench:      140425 ns/iter (+/- 1698)

test async/ws_round_trip/memory_intense ... bench:     6222236 ns/iter (+/- 339249)


Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 6.1s, enable flat sampling, or reduce sample count to 60.
test async/ws_round_trip/slow_call ... bench:     1212700 ns/iter (+/- 13302)

test async/ws_batch_requests/fast_call/2 ... bench:      166526 ns/iter (+/- 3558)
test async/ws_batch_requests/fast_call/5 ... bench:      198525 ns/iter (+/- 680)
test async/ws_batch_requests/fast_call/10 ... bench:      250252 ns/iter (+/- 1416)
test async/ws_batch_requests/fast_call/50 ... bench:      658748 ns/iter (+/- 17170)

Warning: Unable to complete 100 samples in 5.0s. You may wish to increase target time to 5.8s, enable flat sampling, or reduce sample count to 60.
test async/ws_batch_requests/fast_call/100 ... bench:     1157625 ns/iter (+/- 14602)


Warning: Unable to complete 100 samples in 10.0s. You may wish to increase target time to 13.4s, enable flat sampling, or reduce sample count to 60.
test async/http_concurrent_conn_calls/fast_call/16 ... bench:     2657003 ns/iter (+/- 54351)
test async/http_concurrent_conn_calls/fast_call/32 ... bench:     5147011 ns/iter (+/- 147855)
test async/http_concurrent_conn_calls/fast_call/64 ... bench:     9915309 ns/iter (+/- 374427)

test async/ws_concurrent_conn_calls/fast_call/16 ... bench:     1442213 ns/iter (+/- 88364)
test async/ws_concurrent_conn_calls/fast_call/32 ... bench:     2672436 ns/iter (+/- 116480)
test async/ws_concurrent_conn_calls/fast_call/64 ... bench:     5143380 ns/iter (+/- 175494)

test async/ws_concurrent_conn_subs/16 ... bench:     2630373 ns/iter (+/- 75569)
test async/ws_concurrent_conn_subs/32 ... bench:     5058497 ns/iter (+/- 108347)
test async/ws_concurrent_conn_subs/64 ... bench:     9752134 ns/iter (+/- 342605)


Warning: Unable to complete 100 samples in 60.0s. You may wish to increase target time to 86.0s, enable flat sampling, or reduce sample count to 50.
test async/http_concurrent_conn_calls/fast_call/128 ... bench:    17564453 ns/iter (+/- 779776)
test async/http_concurrent_conn_calls/fast_call/256 ... bench:    30148371 ns/iter (+/- 1089606)
test async/http_concurrent_conn_calls/fast_call/512 ... bench:    51383375 ns/iter (+/- 2993947)
test async/http_concurrent_conn_calls/fast_call/1024 ... bench:    96029375 ns/iter (+/- 6154749)

test async/ws_concurrent_conn_calls/fast_call/128 ... bench:    10073366 ns/iter (+/- 164493)
test async/ws_concurrent_conn_calls/fast_call/256 ... bench:    18407917 ns/iter (+/- 318517)
test async/ws_concurrent_conn_calls/fast_call/512 ... bench:    30488601 ns/iter (+/- 435083)
test async/ws_concurrent_conn_calls/fast_call/1024 ... bench:    48706579 ns/iter (+/- 690999)

test async/ws_concurrent_conn_subs/128 ... bench:    17105784 ns/iter (+/- 181072)
test async/ws_concurrent_conn_subs/256 ... bench:    27863422 ns/iter (+/- 643128)
test async/ws_concurrent_conn_subs/512 ... bench:    46924627 ns/iter (+/- 496064)
test async/ws_concurrent_conn_subs/1024 ... bench:    78642343 ns/iter (+/- 904476)

test subscriptions/subscribe ... bench:      240842 ns/iter (+/- 3147)
test subscriptions/subscribe_response ... bench:       14681 ns/iter (+/- 512)
test subscriptions/unsub ... bench:       13188 ns/iter (+/- 633)

```
</details>


ci example:

```yml
.vault-secrets:                    &vault-secrets
  secrets:
    GITHUB_TOKEN:
      vault:                       cicd/gitlab/parity/GITHUB_TOKEN@kv
      file:                        false

check_bench:
  stage:                           check-result
  image:                           paritytech/benchmarks:latest
  variables:
    PROMETHEUS_URL:                "https://thanos.parity-mgmt.parity.io/"
    TRESHOLD:                      20
  <<:                              *vault-secrets
  #get artifacts with output.txt
  needs:
    - job:                         benchmarks
      artifacts:                   true
  script:
    - check_bench_result artifacts/output.txt

```

Local run example:

```bash
export GITHUB_TOKEN=<token>        # Github token with repo permissions
export CI_PROJECT_NAME=<project>   # Github project
export GITHUB_ORG=<org>            # Optional. Github organisation, default = paritytech
export CI_COMMIT_SHA=<current_sha> # Latest commit sha in master
export PROMETHEUS_URL=<url>        # Prometheus/ Thanos URL
export TRESHOLD=20                 # Optional. Threshold to create github issue, default = 20
python3 check_bench_result.py output.txt


export CI_PROJECT_NAME=jsonrpsee   
export PROMETHEUS_URL="https://thanos.parity-mgmt.parity.io"
export TRESHOLD=20
python3 check_bench_result.py output.txt
```


## push_bench_result.py

The script sends metrics to PushGateway, which is scraped by Prometheus.
All metrics from Prometheus get pushed to Thanos.:w
/

ci example:

```yml
send-becnh-result:
  stage:                           send-becnh-result
  image:                           paritytech/benchmarks:latest
  variables:
    PROMETHEUS_URL:                "http://pushgateway.parity-build.parity.io"
  #get artifacts with text file that contains result
  needs:
    - job:                         benchmarks
      artifacts:                   true
  script:
    - export RESULT=<some_result>
    # send common result with general info
    - push_bench_result -t common
                        -p $CI_PROJECT_NAME
                        -n superbench
                        -r $RESULT
                        -u s
                        -s $PROMETHEUS_URL

    # send specific result with detailed info
    - push_bench_result -t specific
                        -p $CI_PROJECT_NAME
                        -n superbench
                        -r $RESULT
                        -u s
                        -l 'commit="'$CI_COMMIT_SHORT_SHA'",cirunner="'$runner'"'
                        -s $PROMETHEUS_URL

 
     # example with values
     push_bench_result --type common \
                       --project substrate-api-sidecar \
                       --name sidecar \
                       --result 33333 \
                       --unit ms \
                       --prometheus-server http://pushgateway.parity-build.parity.io
```

## check_single_bench_results.py

Script compares provided result either with constant or with previuos value from Thanos
If the result exceeds constant or threshold, scripts creates github issue.  
2 env variables should exist: CI_COMMIT_SHA and GITHUB_TOKEN  

ci example:

```yml

send-becnh-result:
  stage:                           check-becnh-result
  image:                           paritytech/benchmarks:latest
  variables:
    PROMETHEUS_URL:                "http://pushgateway.parity-build.parity.io"
    GITHUB_REPO:                   "paritytech/jsonrpsee"
  #get artifacts with text file that contains result
  needs:
    - job:                         benchmarks
      artifacts:                   true
  script:
    - export RESULT=<some_result>
    # To compare with previous result from Prometheus / Thanos:
    - check_single_bench_result.py -m parity_benchmark_common_result_ms \ # Metric name
                                   -p substrate-api-sidecar \             # Benchark project
                                   -n sidecar \                           # Benchmark name
                                   -s $PROMETHEUS_URL \                   # Prometheus server to take last value
                                   -g $GITHUB_ORG \                       # GitHub Org for creating issue
                                   -t 20 \                                # Threshold %
                                   -v $RESULT                             # Result

    # example with values
     check_single_bench_result.py --metric parity_benchmark_common_result_ms  \
                                  --project substrate-api-sidecar \
                                  --name sidecar \
                                  --prometheus-server 'https://thanos.parity-mgmt.parity.io/' \
                                  --github-repo 'paritytech/substrate-api-sidecar' \
                                  --threshold 20 \
                                  --value 35000

    # To compare with constant:
    - check_single_bench_result.py -g 'org/repo'\    # GitHub Org for creating issue
                                   -c 1 \            # Constant to compare
                                   -v $RESULT        # Result

    # example with values
      check_single_bench_result.py --github-repo 'paritytech/substrate-api-sidecar' \
                                   --constant 35000 \
                                   --value 37461.43
```

