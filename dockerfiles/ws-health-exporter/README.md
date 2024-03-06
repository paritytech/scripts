# A WebSocket health checker for Substrate-based nodes

The script:
* opens a WebSocket connection 
* runs `system_health` and `system_syncState` API methods
* closes the WebSocket connection
* checks results: common health state, number of peers, state of syncing, block syncing drift
* exposes health data as a Prometheus endpoint and a simple HTTP probe (can be useful as probes for k8s)

## Configuration
It can be configured using environment variables:
* `WSHE_LOG_LEVEL` - setups the log level; can be `INFO` or `DEBUG`; default `INFO`
* `WSHE_HOST` - setups the host address to bind; default `0.0.0.0`
* `WSHE_PORT` - setups the port number to bind; default `8001`
* `WSHE_WS_CHECK_INTERVAL` - setups the WebSocket check interval in seconds; default `10` seconds
* `WSHE_WS_TIMEOUT` - setups the WebSocket check timeout in seconds; default `60` seconds
* `WSHE_NODE_RPC_URLS` - setups the list of WebSocket URLs; the format is a comma-separated string;
  default `ws://127.0.0.1:5556`
* `WSHE_NODE_MAX_UNSYNCHRONIZED_BLOCK_DRIFT` - setups maximum of unsynchronized blocks; if a node has
  more, the health check will fail; default `0` blocks (disabled)
* `WSHE_NODE_MIN_PEERS` - setups minimum of peers; if a node has less, the health check will fail; default `2` peers
* `WSHE_BLOCK_RATE_MEASUREMENT_PERIOD` - average rate of new blocks is calculated for the period;
  if this period is less than `WSHE_WS_CHECK_INTERVAL` it will be equal `WSHE_WS_CHECK_INTERVAL`; 
  default `600` seconds
* `WSHE_MIN_BLOCK_RATE` - setups minimum rate of new blocks; if a node has a
  lower rate, the health check will fail; default `0.0` blocks/second (disabled)

## API endpoints
GET:
* `/` - list of all HTTP routes
* `/metrics` - Prometheus metric endpoint
* `/health/readiness` - simple HTTP probe (HTTP codes: `200`, `500`); 
  the probe will be failed if at least one check for a URL fails

## Prometheus metrics
Example:
```
wss_alive{url="wss://kusama-rpc.polkadot.io"} 1.0
wss_alive{url="wss://rpc.polkadot.io"} 0.0
```