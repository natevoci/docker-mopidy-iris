FROM jfloff/alpine-python:2.7
MAINTAINER Log1x <github@log1x.com>

ENV PGID=1000 PUID=1000
WORKDIR /mopidy-iris

RUN \
  echo "* Updating Package Repositories" \
    && echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
    && echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
    && echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk upgrade --no-cache \
    && pip install --upgrade pip \
  && echo "* Installing Runtime Packages" \
    && apk add --no-cache \
      libcdio \
      libcaca \
      libvpx@edge \
      libffi-dev \
      openssl-dev \
      v4l-utils-libs@edge \
      py2-gst@edge \
      py-gobject@edge \
      su-exec \
      gstreamer-dev@edge \
      gst-plugins-good@edge \
      gst-plugins-ugly@edge \
    && pip install -U \
      pyopenssl \
      youtube-dl \
  && echo "* Installing Mopidy + Extensions" \
    && pip install -U \
      Mopidy \
      Mopidy-SoundCloud \
      Mopidy-YouTube \
      Mopidy-Local-Images \
      Mopidy-Local-SQLite \
  && echo "* Installing Iris" \
    && pip install -U Mopidy-Iris \
  && echo "* Creating Mopidy User" \
    && addgroup -g ${PGID} mopidy \
    && adduser -h /mopidy -s /bin/sh -D -G mopidy -u ${PUID} mopidy \
  && echo "* Fixing privileges" \
    && mkdir -p /data \
    && chown -R mopidy:mopidy /data \
  && echo "* Ready to start Mopidy" \
  && sleep 10

COPY   mopidy.conf /config/mopidy.conf
COPY   run.sh /usr/local/bin/run.sh
RUN    chmod +x /usr/local/bin/run.sh
EXPOSE 6600 6680 5555/udp
VOLUME ["/music", "/data"]

LABEL description "Open source media server"

CMD ["run.sh"]
