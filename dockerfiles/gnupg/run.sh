#!/usr/bin/env bash

export HOME=/home/user
mkdir -p $HOME/.gnupg
chown user:user $HOME/.gnupg
chmod 700 $HOME/.gnupg
exec chroot --userspec=user / sh -c "cd ${HOME}; $@"
