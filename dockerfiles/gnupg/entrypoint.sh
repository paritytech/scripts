#!/bin/bash

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"

if [ -d "/home/user" ]; then
    useradd --shell /bin/bash -u $USER_ID -o -c "" -M user
  else
    useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
fi
echo "User 'user' created"

export HOME=/home/user
mkdir -p $HOME/.gnupg
chown -R user:user $HOME/.gnupg
chmod 700 $HOME/.gnupg

echo before chroot
whoami
exec chroot --userspec=user / sh -c "cd ${HOME}; $@"
