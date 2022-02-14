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
"""

import sys
import argparse
import requests

def get_arguments():
    parser = argparse.ArgumentParser(description='Push data to Victoria Metrics.')
    parser.add_argument('--type','-t',
                        default='common',
                        choices=['common', 'specific', 'test'],
                        type=str,
                        help='Type of benchmark: common|specific|test')
    parser.add_argument('--project','-p',
                        type=str,
                        required=True,
                        help='Benchmark project (usually name of the repo)')
    parser.add_argument('--name','-n',
                        type=str,
                        required=True,
                        help='Benchmark name')
    parser.add_argument('--result','-r',
                        type=str,
                        required=True,
                        help='Result of benchmark')
    parser.add_argument('--labels','-l',
                        type=str,
                        help='Dictionary with additional labels')
    parser.add_argument('--unit','-u',
                        type=str,
                        default='ns',
                        help='Metric unit (ns,s,bytes,info...)')
    parser.add_argument('--prometheus-server','-s',
                        type=str,
                        required=True,
                        help='Prometheus server address http://prom.com')
    args = parser.parse_args()
    return args

def create_metric(args):
    """
    Creates metric in prometheus format from script arguments
    Common metric doesn't have labels, test metric can have labels
    """
    if args.labels:
        if args.type == 'common':
            print("Common metric shouldn't have additional labels")
            sys.exit(1)
        metric = f"parity_benchmark_{args.type}_result_{args.unit}{{project=\"{args.project}\",benchmark=\"{args.name}\",{args.labels}}} {args.result}"
    else:
        metric = f"parity_benchmark_{args.type}_result_{args.unit}{{project=\"{args.project}\",benchmark=\"{args.name}\"}} {args.result}"
    return metric

def send_metric(server, metric):
    """
    Sends metric to Victoria Metrics server
    https://github.com/VictoriaMetrics/VictoriaMetrics#how-to-import-data-in-prometheus-exposition-format
    """
    url = f"{server}/api/v1/import/prometheus"
    return requests.post(url,data=metric)

def main():
    args = get_arguments()
    metric = create_metric(args)
    send_metric_result = send_metric(args.prometheus_server, metric)
    if send_metric_result.text == '' and send_metric_result.status_code < 400:
        print(f"Metric '{metric}' was successfully sent")
    else:
        print(f"Error occured: \nError code: {send_metric_result.status_code} \nError message: {send_metric_result.text}")

if __name__ == '__main__':
    main()
