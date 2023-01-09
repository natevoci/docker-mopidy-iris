FROM debian:buster

ENV PUID="${PUID:-1000}"
ENV PGID="${PGID:-1000}"

WORKDIR /mopidy

# Install GStreamer and other required Debian packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget \
    gnupg2 \
    git \
    python3-setuptools \
    python3-pip \
    dumb-init \
    graphviz-dev \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    libasound2-dev \
    python3-dev \
    python3-gst-1.0 \
    build-essential \
    libdbus-glib-1-dev \
    libgirepository1.0-dev \
    dleyna-server \
    sudo \
    libcairo2-dev \
    mopidy \
    # mopidy-iris \
    # mopidy-mpd \
    # mopidy-local \
  && rm -rf /var/lib/apt/lists/*

RUN \
  echo "* --------------------" \
  && echo "* Upgrading pip" \
    && python3 -m pip install --upgrade pip

RUN \
  echo "* Starting pip install" \
    && python3 -m pip install -U \
      pyopenssl \
      pygobject

RUN \
  echo "* Installing Mopidy + Extensions" \
    && python3 -m pip install -U \
      # Mopidy \
      Mopidy-Iris \
      Mopidy-Mpd \
      Mopidy-Local \
      Mopidy-Local-Images

RUN \
  echo "* Cleaning up" \
    && rm -rf /tmp/* \
  && echo "* Ready to start Mopidy" \
  && sleep 1

COPY   root/ /
RUN    chmod +x /usr/local/bin/run.sh
RUN    chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 6600 6680 8000
VOLUME /data /music

LABEL description "Open source media server"

ENTRYPOINT ["entrypoint.sh"]
CMD ["run.sh"]
