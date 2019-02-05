#!/bin/sh

noip2 $@

cleanup() {
  echo "Caught Signal ... cleaning up."
  kill -s SIGINT $(pgrep noip2)
  echo "Done cleanup ... quitting."

  while pgrep noip2 > /dev/null; do
    sleep 1;
  done

  exit 1
}

trap cleanup HUP INT QUIT PIPE TERM

# Wait for the noip2 application to finish
while pgrep noip2 > /dev/null; do
    sleep 1;
done
