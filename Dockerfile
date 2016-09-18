FROM debian
MAINTAINER Laurian Gridinoc <laurian@gridinoc.name>

RUN apt-get update \
  && apt-get install -y --force-yes --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  fonts-liberation \
  libfreeimage3 \
  imagemagick \
  python python-dev python-setuptools \
  python-numpy \
  python-pip \
  curl \
  wget \
  libtiff5-dev libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk \
  xz-utils

RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
RUN wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends rabbitmq-server

# RUN curl -L http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz | tar -xJ \
  # && ln -s /ffmpeg-*/ffm* /usr/bin

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

COPY . /opt/app
WORKDIR /opt/app

RUN apt-get remove -y \
  python-pip \
  curl \
  xz-utils \
  && rm -Rf /tmp/* \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 5000
CMD ./run.sh
