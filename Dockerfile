FROM ubuntu:20.04

RUN yes | apt-get update && \
    apt-get install -y git python3 python3-pip sudo libiw-dev

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
RUN apt-get -y install x11-xserver-utils tzdata

WORKDIR /app

ENTRYPOINT /bin/bash
