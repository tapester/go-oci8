#!/bin/sh -e

cd "$(dirname "$(readlink -f "$0")")"

sudo apt-get -qq update
sudo apt-get --no-install-recommends -qq unzip

df -B1 /dev/shm | awk 'END { if ($1 != "shmfs" && $1 != "tmpfs" || $2 < 2147483648) exit 1 }' ||
  ( sudo rm -r /dev/shm && sudo mkdir /dev/shm && sudo mount -t tmpfs shmfs -o size=2G /dev/shm )

test -f /sbin/chkconfig ||
  ( echo '#!/bin/sh' | sudo tee /sbin/chkconfig > /dev/null && sudo chmod u+x /sbin/chkconfig )

test -d /var/lock/subsys || sudo mkdir /var/lock/subsys

unzip -j "$ORACLE_FILE" "*/$ORACLE_FILE"
unzip -j "$ORACLE_FILE_2" "*/$ORACLE_FILE_2"
