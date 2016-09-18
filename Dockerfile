FROM debian
MAINTAINER Laurian Gridinoc <laurian@gridinoc.name>

RUN apt-get update \
  && apt-get install -y --force-yes --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  curl \
  wget

RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
RUN wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -

RUN apt-get update \
  && apt-get install -y --force-yes --no-install-recommends \
  libfreeimage3 \
  imagemagick \
  python python-dev python-setuptools \
  python-numpy python-pip \
  libtiff5-dev libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev \
  liblcms2-dev libwebp-dev \
  tcl8.6-dev tk8.6-dev python-tk \
  xz-utils \
  rabbitmq-server

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

COPY ./etc/ImageMagick-6/type.xml /etc/ImageMagick-6/type.xml
COPY ./etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml
COPY . /opt/app
WORKDIR /opt/app

ENV C_FORCE_ROOT=true
ENV CELERY_ACCEPT_CONTENT="['pickle', 'json', 'msgpack', 'yaml']"
ENV IMAGEMAGICK_BINARY /usr/bin/convert

EXPOSE 5000
CMD ./run.sh

# RUN apt-get remove -y \
#   python-pip \
#   curl \
#   wget \
#   xz-utils \
#   && rm -Rf /tmp/* \
#   && rm -rf /var/lib/apt/lists/*
