#!/usr/bin/env bash

eval 'gpg-agent --daemon'
gpg-agent
/usr/bin/rpm $@
