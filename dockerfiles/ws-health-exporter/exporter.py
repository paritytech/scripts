#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Taken from https://gitlab.parity.io/parity/infrastructure/ansible/collections/chain_operations/-/raw/master/roles/ws_health_exporter/files/exporter.py

import sys
import os
import logging
import traceback
import json

from flask import Flask
from apscheduler.schedulers.background import BackgroundScheduler
from prometheus_client import generate_latest, Gauge
from websocket import create_connection

LOGGING_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

PORT = 8001
WS_NODE_URL = os.environ.get("NODE_URL", "ws://127.0.0.1:5556")
WS_TIMEOUT = 60
ws_metrics = {
    'polkadot_ws_alive': Gauge('wss_alive', 'WebSocket alive', [])
}
# global variable to keep current ws status
readiness_status = False
app = Flask(__name__, static_folder=None)


def check_ws(node_url, timeout):
    try:
        ws = create_connection(node_url, timeout=timeout)
        ws.send('{"id":1, "jsonrpc":"2.0", "method": "system_health", "params":[]}')
        data = json.loads(ws.recv())
        ws.close()
        syncing = data['result']['isSyncing']
        peers = data['result']['peers']
        should_have_peers = data['result']['shouldHavePeers']
        logger.debug(f'syncing: {syncing}, peers: {peers}, should_have_peers: {should_have_peers}')
        if syncing is False and peers > 0:
            return True
        else:
            return False
    except Exception as e:
        logger.error(f'WebSocket request error. url: {node_url}, timeout: {timeout}')
        logger.error(e)
        logger.error(traceback.print_tb(e.__traceback__))
        return False


def update_metrics():
    global readiness_status
    readiness_status = check_ws(WS_NODE_URL, WS_TIMEOUT)
    ws_metrics['polkadot_ws_alive'].set(int(readiness_status))


@app.route('/')
def site_map():
    routes = "Main Page:\n"
    for rule in app.url_map.iter_rules():
        routes += ('%s\n' % rule)
    return routes

@app.route('/metrics')
def metrics():
    return generate_latest()


@app.route('/health/readiness')
def health_readiness():
    if readiness_status:
        return '{"status": "UP"}', 200
    else:
        return '{"status": "DOWN"}', 500

if __name__ == '__main__':
    global logger
    logger = logging.getLogger('ws_exporter')

    # console handler
    ch = logging.StreamHandler()
    if len(sys.argv) > 1 and sys.argv[1] == 'debug':
        logger.setLevel(logging.DEBUG)
    else:
        logger.setLevel(logging.INFO)
    formatter = logging.Formatter(LOGGING_FORMAT)
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    update_metrics()
    scheduler = BackgroundScheduler()
    scheduler.add_job(func=update_metrics, trigger="interval", seconds=10)
    scheduler.start()

    app.run(host='0.0.0.0', port=PORT, use_reloader=False)
