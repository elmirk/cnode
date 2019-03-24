FROM ubuntu:18.04

COPY otp_src_21.1.tar.gz /opt
WORKDIR /opt

#
# install erlang libs for c node
#
RUN set -xe \
        && apt-get update && apt-get install -y gcc make  \
	&& tar -xvf otp_src_21.1.tar.gz \
        && cd otp_src_21.1 \
        && export ERL_TOP=`pwd` \
        && ./configure --without-termcap \
        && export TARGET=`erts/autoconf/config.guess` \
        && cd lib/erl_interface \
        && make opt \
        && make release RELEASE_PATH=/usr/local/lib/erlang \
        && rm /opt/otp_src_21.1.tar.gz \
        && rm -rf /var/cache/apt \
        && apt-get clean

#
# install dialogic gctload lib
#
COPY dpklnx.Z /opt
RUN set -xe \
        && mkdir DSI \
        && tar --no-same-owner -zxvf dpklnx.Z -C DSI \
        && echo "/opt/DSI/32" >> /etc/ld.so.conf \
        && echo "/opt/DSI/64" >> /etc/ld.so.conf \
        && ldconfig \
        && rm dpklnx.Z

#
# copy cnode sources into docker and compile
#
RUN mkdir src

COPY src /opt/src
WORKDIR src
RUN set -xe \
        && make map_user

#	libpthread-stubs make \
#       && mkdir -vp /opt/DSI
#apt-get clean

#TODO:
#
#1. last line in Dockerfile should be CMD or ENTRYPOINT command where we
#run map_user
#2. check gctload sw guide - maybe should tune some params according it
#

