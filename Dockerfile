FROM ubuntu:18.04 as dev

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

FROM ubuntu:18.04 as prod

COPY --from=dev /usr/local/lib/erlang /usr/local/lib/erlang
COPY --from=dev /etc/ld.so.conf /etc/ld.so.conf
COPY --from=dev /opt/DSI/64 /opt/DSI/64
COPY --from=dev /opt/DSI/32 /opt/DSI/32
#COPY --from=dev /etc/localtime /etc/localtime
#COPY --from=dev /etc/timezone /etc/timezone
COPY --from=dev /opt/src/map_user /opt/src/map_user
RUN ldconfig

WORKDIR /opt/src

ENTRYPOINT ["./map_user"]

#TODO:
#
#1. last line in Dockerfile should be CMD or ENTRYPOINT command where we
#run map_user
#2. check gctload sw guide - maybe should tune some params according it
#3. sync time options not set yet

