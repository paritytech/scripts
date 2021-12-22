Docker image to push and check benchmark results

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