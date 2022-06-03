#!/bin/bash

USER_ID=${LOCAL_USER_ID:-1000}

echo "Starting with UID : $USER_ID"

if [ -d "/home/user" ]; then
    useradd --shell /bin/bash -u $USER_ID -o -c "" -M user
  else
    useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
fi
echo "User 'user' created"

export HOME=/home/user
chown -R user:user $HOME
mkdir -p $HOME/.gnupg
chmod 700 $HOME/.gnupg
chown -R user:user $HOME/.gnupg

exec chroot --userspec=user / sh -c "cd ${HOME}; $@"
