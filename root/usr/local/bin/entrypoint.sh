#!/bin/sh

set -eu

[ ! -r /data/.config ] && mkdir -p /data/.config
[ ! -r /data/.images ] && mkdir -p /data/.images
[ ! -r /data/.config/mopidy.conf ] && cp /defaults/mopidy.conf /data/.config
[ ! -r /data/.config/icecast.xml ] && cp /defaults/icecast.xml /data/.config

if [ ! -r /data/icecast/web ] || [ ! -r /data/icecast/admin ] || [ ! -r /data/icecast/logs ]; then
    mkdir -p /data/icecast/web /data/icecast/admin /data/icecast/logs
    cp -r /usr/share/icecast /data/icecast
    cp /defaults/silence.mp3 /data/icecast/web/silence.mp3
fi

mv /etc/mopidy/mopidy.conf /etc/mopidy/mopidy.conf.orig
cp /data/.config/mopidy.conf /etc/mopidy/mopidy.conf

chown -R mopidy:audio /data

# mopidyctl config
mopidyctl local scan

exec "${@}"
