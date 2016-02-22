# martinsoto/gateone

FROM python:2.7

MAINTAINER Martin Soto <donsoto@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install a recent Pip.
RUN curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py \
    && python /tmp/get-pip.py \
    && rm /tmp/get-pip.py

RUN pip install --upgrade futures tornado cssmin slimit psutil

RUN apt-get update \
    && apt-get install -y python-imaging python-mutagen \
    && apt-get install -y python-dev git \
    && cd /tmp \
    && git clone https://github.com/liftoff/GateOne.git \
    && cd GateOne \
    && python setup.py install \
    && cd / \
    && rm -rf /gateone/GateOne \
    && apt-get remove --purge -y python-dev git \
    && apt-get autoremove -y \
    && apt-get clean

# Configuration.
RUN mkdir -p /etc/gateone/conf.d \
    && mkdir -p /etc/gateone/ssl
RUN /usr/local/bin/gateone --configure --auth=none --disable_ssl --port=8000
ADD terminal.conf /etc/gateone/conf.d/50terminal.conf

EXPOSE 8000

CMD gateone

