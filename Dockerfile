ARG ARCH=amd64
FROM bayrell/ubuntu:jammy-${ARCH}

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	apt-get update; \
	apt-get install sphinxsearch -y; \
	apt-get clean all; \
	rm -rf /var/lib/sphinxsearch; \
	ln -s /data/sphinxsearch /var/lib/sphinxsearch; \
	rm /root/run.d/00-env.sh; \
	echo 'Ok'

ADD files /
ENTRYPOINT ["/root/run.sh"]
