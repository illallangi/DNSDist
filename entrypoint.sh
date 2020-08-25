#!/usr/bin/env sh

UMASK=$(which umask)
UMASK_SET=${UMASK_SET:-022}

if [[ ! -x $UMASK ]]; then
  echo "umask binary not found"
  exit 1
fi

echo $UMASK "$UMASK_SET"
$UMASK "$UMASK_SET"

CONFD=$(which confd)

if [[ ! -x $CONFD ]]; then
  echo "confd binary not found"
  exit 1
fi

echo $CONFD -onetime -backend env -log-level debug
$CONFD -onetime -backend env -log-level debug || exit 1

DNSDIST=$(which dnsdist)
if [[ ! -x $DNSDIST ]]; then
  echo "dnsdist binary not found"
  exit 1
fi

echo ${*:-${DNSDIST} -u dnsdist -g dnsdist --supervised --disable-syslog}
exec ${*:-${DNSDIST} -u dnsdist -g dnsdist --supervised --disable-syslog}