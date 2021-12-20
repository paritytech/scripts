#!/usr/bin/env python3
"""
The script compares current benchmark result with the previous
and creates an issue in GitHub if it exceeds the threshold
Usage: check_bench_result.py <file with benchmark results> <github_org>
Example: check_bench_result.py output.txt
"""

import os
import sys
from prometheus_api_client import PrometheusConnect
from github import Github

try:
    github_org = os.environ['GITHUB_ORG']
except KeyError:
    github_org = "paritytech"

try:
    results_file = sys.argv[1]
    github_token = os.environ['GITHUB_TOKEN']
    github_repo = os.environ['CI_PROJECT_NAME']
    github_repo_full = f"{github_org}/{github_repo}"
    current_sha = os.environ['CI_COMMIT_SHA']
    prometheus_url = os.environ['PROMETHEUS_URL']
except KeyError as error:
    print(f"{error} not found in environment variables")
    sys.exit(1)
except IndexError:
    print("Please specify file with benchmark results and github_org")
    print("Usage:",sys.argv[0],"<file with benchmark results>")
    sys.exit(1)

try:
    treshold = os.environ['THRESHOLD']
except KeyError:
    treshold = 20

prometheus_client = PrometheusConnect(url=prometheus_url, disable_ssl=True)
github_client = Github(github_token)

def benchmark_last(project,benchmark):
    """Get latest benchmark result from Victoria Metrics"""
    query = f"last_over_time(parity_benchmark_common_result_ns{{project=\"{project}\",benchmark=\"{benchmark}\"}}[1y])"
    query_result = prometheus_client.custom_query(query=query)
    last_benchmark_result = int(query_result[0]['value'][1])
    return last_benchmark_result

def create_github_issue(benchmarks_list,github_org_repo):
    """Create github issue with list of benchmarks"""
    # repo = github_client.get_repo(github_org_repo)
    repo = github_client.get_repo("tripleightech/gl-gh-test")
    last_sha = repo.get_commits()[1].sha
    commit_url = f"https://github.com/{github_repo_full}/commit/"
    benchmarks_mstring = "\n".join(benchmarks_list)
    issue_text = f"""
## Benchmarks have regressions

Threshold: {treshold}%

These benchmarks have regressions:

| Benchmark name | Previous result [{last_sha[:8]}]({commit_url}{last_sha}) | Current result [{current_sha[:8]}]({commit_url}{current_sha}) | Ratio |
|---|---|---|---|
{benchmarks_mstring}
                 """
    github_issue = repo.create_issue(title="[benchmarks] Regression detected", body=issue_text)
    return github_issue

if __name__ == "__main__":
    output_file = open(results_file, 'r')
    bench_results = output_file.readlines()
    output_file.close()
    benchmarks_with_regression = []
    for result in bench_results:
        if not "test" in result:
            continue
        benchmark_name = result.split()[1]
        benchmark_current_value = int(result.split()[4])
        try:
            benchmark_last_value = benchmark_last(github_repo,benchmark_name)
        except IndexError:
            print(benchmark_name,"doesn't have data, skipping")
            continue
        if benchmark_current_value > benchmark_last_value:
            ratio = benchmark_current_value * 100 / benchmark_last_value
            subt = round(abs(100 - ratio))
            if subt > treshold:
                regression = True
                string_to_add = f"| {benchmark_name} | {benchmark_last_value} ns/iter | {benchmark_current_value} ns/iter | {subt}% |"
                benchmarks_with_regression.append(string_to_add)
            else:
                regression = False
    if len(benchmarks_with_regression) > 0:
        print("Regression found, creating GitHub issue")
        issue = create_github_issue(benchmarks_with_regression,github_repo_full)
        print(issue)
    else:
        print("No regressions")
