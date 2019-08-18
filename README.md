# docker-proxy-tools

## 服务器端使用docker-compose.yml运行udp2raw udpspeederv2 kcptun shadowsocks
## udp2raw(faketcp) -> kcptun(udp) -> shadowsocks(tcp)
## udp2raw(faketcp) -> udpspeederv2(udp) -> shadowsocks(udp)

```
version: "3"

services:
  proxy-ss-server:
    image: wuwengang/proxy-tools:ss
    command: >-
        ss-server
        -s 0.0.0.0
        -p 6443
        -k 123456
        -m aes-256-cfb
        -u
    ports:
      - "6443:6443/tcp"
      - "6443:6443/udp"
    networks:
      proxy:
        ipv4_address: 11.11.11.1
    restart: always
  proxy-kcptun-server:
    image: wuwengang/proxy-tools:kcptun
    command: >-
      server
      -l 0.0.0.0:6500
      -t 11.11.11.1:6443
      --key none
      -mode fast2
      --ds 0
      --ps 0
      --crypt none
      --mtu 1350
      --sndwnd 2048
      --rcvwnd 512
      --nocomp
    ports:
      - "6500:6500/udp"
    networks:
      proxy:
        ipv4_address: 11.11.11.2
    depends_on:
      - proxy-ss-server
    restart: always
  proxy-udpspeederv2-server:
    image: wuwengang/proxy-tools:udpspeederv2
    command: >-
        -s
        -l0.0.0.0:6501
        -r 11.11.11.1:6443
        -f1:3,2:4,8:6,20:10
        -k 123456
    ports:
      - "6501:6501/udp"
    networks:
      proxy:
        ipv4_address: 11.11.11.3
    depends_on:
      - proxy-ss-server
    restart: always
  proxy-udp2raw-tcp-server:
    image: wuwengang/proxy-tools:udp2raw
    cap_add:
      - NET_ADMIN
    command: >-
      -s
      -l0.0.0.0:7096
      -r 11.11.11.2:6500
      -k 123456
      --cipher-mode xor
      --auth-mode simple
      --raw-mode faketcp
      -a
    ports:
      - "7096:7096"
    networks:
      proxy:
        ipv4_address: 11.11.11.4
    depends_on:
      - proxy-kcptun-server
    restart: always
  proxy-udp2raw-udp-server:
    image: wuwengang/proxy-tools:udp2raw
    cap_add:
      - NET_ADMIN
    command: >-
      -s
      -l0.0.0.0:7097
      -r 11.11.11.3:6501
      -k 123456
      --cipher-mode xor
      --auth-mode simple
      --raw-mode faketcp
      -a
    ports:
      - "7097:7097"
    networks:
      proxy:
        ipv4_address: 11.11.11.5
    depends_on:
      - proxy-udpspeederv2-server
    restart: always
#  proxy-udp2raw-tcp-server:
#    image: wuwengang/proxy-tools:udp2raw
#    cap_add:
#      - NET_ADMIN
#    command: >-
#      -s
#      -l0.0.0.0:7096
#      -r 127.0.0.1:6500
#      -k 123456
#      --cipher-mode xor
#      --auth-mode simple
#      --raw-mode faketcp
#      -a
#    network_mode: "host"
#    depends_on:
#      - proxy-kcptun-server
#    restart: always
#  proxy-udp2raw-udp-server:
#    image: wuwengang/proxy-tools:udp2raw
#    cap_add:
#      - NET_ADMIN
#    command: >-
#      -s
#      -l0.0.0.0:7097
#      -r 127.0.0.1:6501
#      -k 123456
#      --cipher-mode xor
#      --auth-mode simple
#      --raw-mode faketcp
#      -a
#    network_mode: "host"
#    depends_on:
#      - proxy-udpspeederv2-server
#    restart: always

networks:
  proxy:
    driver: bridge
    ipam:
      config:
        - subnet: 11.11.11.0/16
```