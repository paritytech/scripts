#!/bin/sh
export RUNNER_ALLOW_RUNASROOT=1

./config.sh --unattended --token "$RUNNER_TOKEN" --url "$REPO_URL"

./run.sh
