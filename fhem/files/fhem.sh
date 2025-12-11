#!/bin/sh /etc/rc.common
# FHEM Init Script

START=99
STOP=01

start() {
  if [ ! -e /var/log/fhem ]; then
  mkdir -p /var/log/fhem
  chown fhem:fhem /var/log/fhem
  fi

  if [ ! -e /var/cache/fhem ]; then
  mkdir -p /var/cache/fhem
    if [ ! -e /var/cache/fhem/uniqueID ]; then
    ln -s /etc/config/fhem/uniqueID /var/cache/fhem/uniqueID
    fi
  chown fhem:fhem /var/cache/fhem
  fi

  if [ ! -e /var/run/fhem.pid ]; then
  touch /var/run/fhem.pid
  chown fhem:fhem /var/run/fhem.pid
  fi

  for CFG in `find /etc/config/fhem/mod.cfg.d/ -type f -name "*.cfg" | sort`; do echo include $CFG; done > /tmp/new-fhem-mod.cfg
  cmp -s /tmp/new-fhem-mod.cfg /etc/config/fhem/mod.cfg || (cp /tmp/new-fhem-mod.cfg /etc/config/fhem/mod.cfg && chown fhem:fhem /etc/config/fhem/mod.cfg)
  rm /tmp/new-fhem-mod.cfg

  cd /usr/share/fhem

  /usr/bin/fhem /etc/config/fhem/fhem.cfg
}

stop(){
  echo "stopping fhem"
  kill -TERM $(cat /var/run/fhem.pid)
}

