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
    threshold = os.environ['THRESHOLD']
except KeyError:
    threshold = 20

prometheus_client = PrometheusConnect(url=prometheus_url, disable_ssl=True)
github_client = Github(github_token)

def benchmark_last(project,benchmark):
    """
    Get latest benchmark result from Victoria Metrics
    Returns "-1" if result not found
    """
    query = f"last_over_time(parity_benchmark_common_result_ns{{project=\"{project}\",benchmark=\"{benchmark}\"}}[1y])"
    query_result = prometheus_client.custom_query(query=query)
    if len(query_result) > 0:
        last_benchmark_result = int(query_result[0]['value'][1])
    else:
        last_benchmark_result = -1
    return last_benchmark_result

def create_github_issue(benchmarks_list,github_org_repo):
    """Create github issue with list of benchmarks"""
    repo = github_client.get_repo(github_org_repo)
    last_sha = repo.get_commits()[1].sha
    commit_url = f"https://github.com/{github_repo_full}/commit/"
    benchmarks_mstring = "\n".join(benchmarks_list)
    issue_text = f"""
## Benchmarks have regressions

Threshold: {threshold}%

These benchmarks have regressions:

| Benchmark name | Previous result [{last_sha[:8]}]({commit_url}{last_sha}) (ns/iter) | Current result [{current_sha[:8]}]({commit_url}{current_sha}) (ns/iter) | Difference (%) |
|---|---|---|---|
{benchmarks_mstring}
                 """
    github_issue = repo.create_issue(title="[benchmarks] Regression detected", body=issue_text)
    return github_issue

def get_name_value(line):
    """Get benchmark name and result from a text line"""
    name = line.split()[1]
    value = int(line.split()[4])
    return name,value

def check_line_valid(line):
    """
    Check that line can be transformed to a list with 8 values
    Expects line "test <benchmark_name_with_underscores> ... bench:  <bench_result> ns/iter (+/- <bench_result_difference_between_max_min>)"
    """
    if len(line.split()) != 8:
        print("Data has wrong format")
        sys.exit(1)
    pass

def difference_p(first,second):
    """Calculate difference between 2 values in percent"""
    return round(abs(first * 100 / second - 100))

if __name__ == "__main__":
    benchmarks_with_regression = []
    with open(results_file, 'r') as file_handle:
        for result in file_handle:
            # Skipping lines without benchmark results
            if not "test" in result:
                continue
            check_line_valid(result)
            benchmark_name,benchmark_current_value = get_name_value(result)
            benchmark_last_value = benchmark_last(github_repo,benchmark_name)
            if benchmark_last_value == -1:
                print(benchmark_name,"is new and doesn't have any data yet, skipping")
                continue
            if benchmark_current_value > benchmark_last_value:
                diff = difference_p(benchmark_current_value,benchmark_last_value)
                if diff > threshold:
                    string_to_add = f"| {benchmark_name} | {benchmark_last_value} ns/iter | {benchmark_current_value} ns/iter | {diff}% |"
                    benchmarks_with_regression.append(string_to_add)
    if len(benchmarks_with_regression) > 0:
        print("Regression found, creating GitHub issue")
        issue = create_github_issue(benchmarks_with_regression,github_repo_full)
        print(issue)
    else:
        print("No regressions")

