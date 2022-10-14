Docker image to push and check benchmark results

Long term storage metrics is done with Thanos now
https://github.com/paritytech/devops/wiki/DevOps-Internal%3A-Thanos

### Thanos Query Frontend https://thanos.parity-mgmt.parity.io/

TODO:
- [ ] do a request example to get metrics from Thanos
## check_bench_result.py

The script takes an output file of `carg bench`, compares current result with the 
latest result and creates a github issue if the threshold is exceeded.

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
    PROMETHEUS_URL:                "http://vm-longterm.parity-build.parity.io"
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
export PROMETHEUS_URL=<url>        # Prometheus/VictoriaMetrics URL
export TRESHOLD=20                 # Optional. Threshold to create github issue, default = 20
python3 check_bench_result.py output.txt
```


## push_bench_result.py

The script sends metrics to Victoria Metrics.

ci example:

```yml
send-becnh-result:
  stage:                           send-becnh-result
  image:                           paritytech/benchmarks:latest
  variables:
    PROMETHEUS_URL:                "http://vm-longterm.parity-build.parity.io"
    PROMETHEUS_URL:                "http://pushgateway.parity-build.parity.io"
  #get artifacts with text file that contains result
  needs:
    - job:                         benchmarks
      artifacts:                   true
  script:
    - export RESULT=<some_result>
    # send common result with general info
    - push_bench_result.py -t common
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

Script compares provided result either with constant or with previuos value from Victoria Metrics.  
If the result exceeds constant or threshold, scripts creates github issue.  
2 env variables should exist: CI_COMMIT_SHA and GITHUB_TOKEN  

ci example:

```yml

send-becnh-result:
  stage:                           check-becnh-result
  image:                           paritytech/benchmarks:latest
  variables:
    PROMETHEUS_URL:                "http://vm-longterm.parity-build.parity.io"
    GITHUB_REPO:                   "paritytech/jsonrpsee"
  #get artifacts with text file that contains result
  needs:
    - job:                         benchmarks
      artifacts:                   true
  script:
    - export RESULT=<some_result>
    # To compare with previous result from Prometheus / Victoria Metrics:
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
                                  --prometheus-server 'http://vm-longterm.parity-build.parity.io' \
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

