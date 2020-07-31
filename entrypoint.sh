#!/bin/bash

PUMA_MASTER_PIDFILE=/usr/src/app/puma.pid

start_puma_master ()
{
  echo "Starting puma master"
  bundle exec puma --pidfile "${PUMA_MASTER_PIDFILE}" &
}

start_phased_restart ()
{
  echo "Starting phased restart"
  bundle exec pumactl -P "${PUMA_MASTER_PIDFILE}" phased-restart || exit
}

test_connection ()
{
  sleep 10
  echo "Testing connection to puma master"
  curl -4 --retry 5 --retry-connrefused --silent --show-error http://localhost:3000 > /dev/null || exit
}

main ()
{
  start_puma_master
  test_connection

  start_phased_restart
  test_connection

  wait
}

main
