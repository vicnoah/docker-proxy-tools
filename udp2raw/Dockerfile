FROM alpine:3.9

COPY Makefile /usr/src/

WORKDIR /usr/src

RUN set -ex; \
	apk add --no-cache \
		build-base \
		git \
		linux-headers \
	; \
	git clone https://github.com/wangyu-/udp2raw-tunnel.git; \
	cd udp2raw-tunnel; \
	cat /usr/src/Makefile >> makefile; \
	make -j$(nproc) docker; \
	strip -s udp2raw-tunnel; \
	chmod +x udp2raw-tunnel;


FROM alpine

COPY --from=0 /usr/src/udp2raw-tunnel/udp2raw-tunnel /usr/local/bin/

RUN set -ex; \
	apk add --no-cache \
		iptables \
		libstdc++ \
	;

ENTRYPOINT ["/usr/local/bin/udp2raw-tunnel"]
