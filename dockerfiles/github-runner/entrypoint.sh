#!/bin/sh
export RUNNER_ALLOW_RUNASROOT=1

get_registration_token(){
  token="$(curl \
    -X POST \
    -H "Authorization: token $ADMIN_TOKEN" \
    "https://api.github.com/repos/$REPO/actions/runners/registration-token" | \
    jq -r .token
  )"
  if [ "$RUNNER_TOKEN" = "null" ]; then
    echo "[!] Something went wrong generating registration token."
    exit
  fi
  echo "$token"
}

RUNNER_TOKEN=$(get_registration_token)

# Is this even considered a sane thing to do?
ADMIN_TOKEN=""

./config.sh --unattended --token "$RUNNER_TOKEN" --url "https://github.com/$REPO"

# blank the runner token before starting the runner
RUNNER_TOKEN=""

./run.sh

