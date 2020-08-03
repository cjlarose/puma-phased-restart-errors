#!/bin/bash

PUMA_MASTER_PIDFILE=/usr/src/app/puma.pid
REQUEST_BODY_SIZE=16384

start_puma_master ()
{
  echo "Starting puma master"
  bundle exec puma --pidfile "${PUMA_MASTER_PIDFILE}" > /dev/null &
}

repeatedly_request_phased_restarts ()
{
  while :
  do
    bundle exec pumactl -P "${PUMA_MASTER_PIDFILE}" phased-restart > /dev/null 2>&1 || exit
    sleep 1
  done
}

random_string () {
  LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c "$REQUEST_BODY_SIZE"
}

repeatedly_send_requests ()
{
  while :
  do
    if ! random_string | curl \
      --show-error \
      --silent \
      --fail \
      --request POST \
      --data @- \
      http://localhost:3000 > /dev/null; then
      echo "Failure!"
    else
      echo -n "."
    fi
  done
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

  echo "Server is ready. Starting phased restarts and requests"

  repeatedly_request_phased_restarts &
  repeatedly_send_requests &
  repeatedly_send_requests &
  repeatedly_send_requests &
  repeatedly_send_requests &

  wait
}

main
