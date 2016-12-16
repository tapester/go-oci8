#!/bin/sh -e
# vim: set et sw=2 ts=2:

[ -z "$ORACLE_DOWNLOAD_DIR" ] || ORACLE_DOWNLOAD_DIR="$(readlink -f "$ORACLE_DOWNLOAD_DIR")/"
[ -n "$ORACLE_FILE" ] || { echo "Missing ORACLE_FILE environment variable!"; exit 1; }
[ -n "$ORACLE_HOME" ] || { echo "Missing ORACLE_HOME environment variable!"; exit 1; }

cd "$(dirname "$(readlink -f "$0")")"

dpkg -s bc libaio1 rpm unzip > /dev/null 2>&1 ||
  ( sudo apt-get -qq update && sudo apt-get --no-install-recommends -qq install bc libaio1 rpm unzip )

df -B1 /dev/shm | awk 'END { if ($1 != "shmfs" && $1 != "tmpfs" || $2 < 2147483648) exit 1 }' ||
  ( sudo rm -r /dev/shm && sudo mkdir /dev/shm && sudo mount -t tmpfs shmfs -o size=2G /dev/shm )

test -f /sbin/chkconfig ||
  ( echo '#!/bin/sh' | sudo tee /sbin/chkconfig > /dev/null && sudo chmod u+x /sbin/chkconfig )

test -d /var/lock/subsys || sudo mkdir /var/lock/subsys

unzip -j "${ORACLE_DOWNLOAD_DIR}$(basename "$ORACLE_FILE")" -d "$ORACLE_HOME"
