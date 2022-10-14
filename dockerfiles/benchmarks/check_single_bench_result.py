#!/usr/bin/env python3
"""
Script compares provided result either with constant or with previuos value from Victoria Metrics.
If the result exceeds constant or threshold, scripts creates github issue.
2 env variables should exist: CI_COMMIT_SHA and GITHUB_TOKEN

Examples:
To compare with previous result from Prometheus / Victoria Metrics:
check_single_bench_result.py -m parity_benchmark_common_result_ms \
                             -p substrate-api-sidecar \
                             -n sidecar \
                             -s 'http://prometheus.io/' \
                             -g 'org/repo'\
                             -t 20 \
                             -v 15
To compare with constant:
check_single_bench_result.py -g 'org/repo'\
                             -c 1 \
                             -v 15

"""

import argparse
from os import environ
from sys import exit

from prometheus_api_client import PrometheusConnect
from github import Github


def get_arguments():
    parser = argparse.ArgumentParser(
        description="Check that provided value doesn't exceed constant or threshold"
    )
    parser.add_argument(
        "-v",
        "--value",
        type=str,
        required=True,
        help="Value for comparison with constant/threshold",
    )
    parser.add_argument(
        "-g",
        "--github-repo",
        type=str,
        required=True,
        help="Github url for creating issue",
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-t",
        "--threshold",
        type=str,
        help="Threshold (%%) which the metric shouldn't exceed",
    )
    group.add_argument(
        "-c",
        "--constant",
        type=str,
        help="Constant with which the metric should be compared",
    )
    parser.add_argument(
        "-s",
        "--prometheus-server",
        type=str,
        help="Prometheus server address",
    )
    parser.add_argument(
        "-m",
        "--metric",
        type=str,
        help="Metric name",
        metavar="parity_benchmark_common_result_ms",
    )
    parser.add_argument(
        "-p",
        "--project",
        type=str,
        help="Benchmark project (usually name of the repo)",
    )
    parser.add_argument("-n", "--name", type=str, help="Benchmark name")
    args = parser.parse_args()
    if args.threshold and (
        args.project is None
        or args.metric is None
        or args.prometheus_server is None
        or args.name is None
    ):
        parser.error(
            "-t/--threshold requires -p/--project, -m/--metric, -n/--name and  -s/--prometheus-server"
        )

    return args


def is_metric_exceed_threshold(
    value1: float, value2: float, threshold: int
) -> bool:
    return abs(100 - value1 * 100 / value2) > threshold


def is_metric_exceed_constant(value: float, constant: int) -> bool:
    return value > constant


def get_benchmark_last_result(
    metric_name: str,
    project: str,
    benchmark: str,
    prometheus_client: PrometheusConnect,
) -> float:
    """
    Get latest benchmark result from Victoria Metrics
    Returns "-1" if result not found
    :param metric_name: Full metric name (e.g. parity_benchmark_common_result_ms)
    :param project: Project name
    :param benchmark: Benchmark name
    :param prometheus_client: PrometheusConnect object
    :return: Last value or -1
    """
    query = f'last_over_time({metric_name}{{project="{project}",benchmark="{benchmark}"}}[1y])'
    query_result = prometheus_client.custom_query(query=query)
    if len(query_result) > 0:
        return float(query_result[0]["value"][1])
    return -1


def create_github_issue(github_client: Github, github_repo: str, reason: str):
    """Create github issue with benchmark result"""
    current_sha = get_variable_from_env("CI_COMMIT_SHA")
    commit_url = f"https://github.com/{github_repo}/commit/"
    repo = github_client.get_repo(github_repo)
    issue_text = f"""
Regression detected for commit: [{current_sha[:8]}]({commit_url}{current_sha})

{reason}
    """
    github_issue = repo.create_issue(
        title="[benchmarks] Regression detected", body=issue_text
    )
    return github_issue


def get_variable_from_env(variable: str):
    result = environ.get(variable)
    if result is None:
        print(f"{variable} not found in env variables, exiting")
        exit(1)
    return result


def main():
    args = get_arguments()
    # Compare with constant
    if args.threshold is None:
        is_metric_exceed = is_metric_exceed_constant(
            float(args.value), int(args.constant)
        )
        reason = f"Current result (**{args.value}**) exceeds constant value (**{args.constant}**)"
    # Compare with threshold
    elif args.constant is None:
        prometheus_client = PrometheusConnect(
            url=args.prometheus_server, disable_ssl=True
        )
        last_result = get_benchmark_last_result(
            args.metric, args.project, args.name, prometheus_client
        )
        print("Last benchmark result is", last_result)
        is_metric_exceed = is_metric_exceed_threshold(
            float(args.value), last_result, int(args.threshold)
        )
        reason = f"Difference between current result (**{args.value}**) and previous result (**{last_result}**) exceeds threshold **{args.threshold}%**"
    if is_metric_exceed:
        print("Regression found")
        print("Creating issue")
        github_repo = args.github_repo
        github_client = Github(get_variable_from_env("GITHUB_TOKEN"))
        print(create_github_issue(github_client, github_repo, reason))
    else:
        print("No regressions")


if __name__ == "__main__":
    main()
