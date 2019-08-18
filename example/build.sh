#!/bin/sh

cd ../kcp && \
docker build -t proxy-kcptun:latest . && \
cd ../ss && \
docker build -t proxy-ss:latest . && \
cd ../udp2raw && \
docker build -t proxy-udp2raw:latest . && \
cd ../udpspeeder && \
docker build -t proxy-udpspeederv2:latest .