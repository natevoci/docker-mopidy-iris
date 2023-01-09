#!/bin/sh

trap "kill $PID" HUP INT TERM
mopidy --config /data/.config/mopidy.conf "${@}" &
PID=$!
wait $PID
