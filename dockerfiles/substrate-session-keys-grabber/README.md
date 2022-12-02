A Substrate session keys grabber

## Overview

The utility re-constructs session key of a Substrate node by inspecting individual keys in the keystore and printing the key to STDOUT.

## Usage

Launch the script directly with:

```
python src/grabber.py /path/to/node/keystore
```

Add it as an extra init container when using the [node helm-chart](https://github.com/paritytech/helm-charts/tree/main/charts/node):

```
extraInitContainers:
- name: dump-session-keys
    image: docker.io/paritytech/substrate-session-keys-grabber:latest
    args: ["/keystore"]
    volumeMounts:
    - mountPath: /keystore
        name: chain-keystore
```