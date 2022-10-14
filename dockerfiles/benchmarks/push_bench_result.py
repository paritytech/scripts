#!/usr/bin/env python3
"""
Push data to Victoria Metrics
Usage: python3 push_bench_result.py -t <common(default)|specific|test> \
                                 -p <benchmark_name> \
                                 -n <benchmark_project> \
                                 -r <benchmark_result> \
                                 -u <benchmark_units (default: ns)> \
                                 -l <additinal_labels_for_specific_benchmarks>
                                 -s <prometheus_server>

Example: python3 push_bench_result.py -t specific \
                                   -p $CI_PROJECT_NAME \
                                   -n superbench \
                                   -r 15 \
                                   -u ns \
                                   -l 'commit="1qw2f43984uf",cirunner="ci5"' \
                                   -s 'http://prometheus.address'
If you need to pass some variables to the label then string should look like: 'commit="'$commit'",cirunner="'$runner'"'

EXAMPLE:
./push_bench_result.py --type common \
                       --project substrate-api-sidecar \
                       --name sidecar \
                       --result 34444 \
                       --unit ms \
                       --prometheus-server https://pushgateway.parity-build.parity.io
Metric 'parity_benchmark_common_result_ms{project="substrate-api-sidecar",benchmark="sidecar"} 34444' was successfully   sent
"""

import sys
import argparse
import requests


def get_arguments():
    parser = argparse.ArgumentParser(
        description="Push data to Victoria Metrics."
    )
    parser.add_argument(
        "--type",
        "-t",
        default="common",
        choices=["common", "specific", "test"],
        type=str,
        help="Type of benchmark: common|specific|test",
    )
    parser.add_argument(
        "--project",
        "-p",
        type=str,
        required=True,
        help="Benchmark project (usually name of the repo)",
    )
    parser.add_argument(
        "--name", "-n", type=str, required=True, help="Benchmark name"
    )
    parser.add_argument(
        "--result", "-r", type=str, required=True, help="Result of benchmark"
    )
    parser.add_argument(
        "--labels", "-l", type=str, help="Dictionary with additional labels"
    )
    parser.add_argument(
        "--unit",
        "-u",
        type=str,
        default="ns",
        help="Metric unit (ns,s,bytes,info...)",
    )
    parser.add_argument(
        "--prometheus-pushgateway",
        "-s",
        type=str,
        required=True,
        help="Prometheus server address http://prom.com",
    )
    args = parser.parse_args()
    return args


def create_metric(args):
    """
    Creates metric in prometheus format from script arguments
    Common metric doesn't have labels, test metric can have labels
    """
    if args.labels:
        if args.type == "common":
            print("Common metric shouldn't have additional labels")
            sys.exit(1)
        metric_name = f'parity_benchmark_{args.type}_result_{args.unit}{{project="{args.project}",benchmark="{args.name}",{args.labels}}}'
    else:
        metric_name = f'parity_benchmark_{args.type}_result_{args.unit}{{project="{args.project}",benchmark="{args.name}"}}'
    return metric_name, args.result


def send_metric(server, metric_name, metric_value):
    """
    Sends metric to Prometheus push gateway
    https://github.com/VictoriaMetrics/VictoriaMetrics#how-to-import-data-in-prometheus-exposition-format

    https://github.com/prometheus/pushgateway#command-line
    echo "some_metric 3.14" | curl --data-binary @- http://pushgateway.example.org:9091/metrics/job/some_job
    """
    url = f"{server}/metrics/job/${metric_name}"
    # \n is required to signal end of input stream
    data = f"{metric_name} {metric_value}\n"
    return requests.post(url, data=data)


def main():
    args = get_arguments()
    metric_name, metric_value = create_metric(args)
    send_metric_result = send_metric(
        args.prometheus_server, metric_name, metric_value
    )
    if send_metric_result.text == "" and send_metric_result.status_code < 400:
        print(f"Metric '{metric_name} {metric_value}' was successfully sent")
    else:
        print(
            f"Error occured: \nError code: {send_metric_result.status_code} \nError message: {send_metric_result.text}"
        )


if __name__ == "__main__":
    main()
