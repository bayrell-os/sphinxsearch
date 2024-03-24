#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
IMAGE="sphinxsearch"
VERSION="2.2"
SUBVERSION=1
TAG=`date '+%Y%m%d_%H%M%S'`

if [ "$APT_MIRROR" = "" ]; then
	APT_MIRROR=""
fi

case "$1" in
	
	test)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG \
			--file Dockerfile --progress=plain --build-arg ARCH=amd64
	;;
	
	amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION \
			--file Dockerfile --progress=plain --build-arg ARCH=amd64
	;;
	
	arm64v8)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR \
			--platform linux/arm64/v8
	;;
	
	arm32v7)
		export DOCKER_DEFAULT_PLATFORM=linux/arm/v7
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7 \
			--file Dockerfile --build-arg ARCH=arm32v7 --build-arg APT_MIRROR=$APT_MIRROR \
			--platform linux/arm/v7
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_$IMAGE-*
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 bayrell/$IMAGE:$VERSION-amd64
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 bayrell/$IMAGE:$VERSION-arm64v8
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7 bayrell/$IMAGE:$VERSION-arm32v7
		
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		
		docker push bayrell/$IMAGE:$VERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-arm64v8
		docker push bayrell/$IMAGE:$VERSION-arm32v7
		
		docker manifest create bayrell/$IMAGE:$VERSION-$SUBVERSION \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		docker manifest push bayrell/$IMAGE:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/$IMAGE:$VERSION \
			--amend bayrell/$IMAGE:$VERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-arm64v8 \
			--amend bayrell/$IMAGE:$VERSION-arm32v7
		docker manifest push bayrell/$IMAGE:$VERSION
	;;
	
	upload-github)
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-amd64
		
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		
		docker manifest create --amend \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm32v7 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		docker manifest push --purge ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION
		
		docker tag bayrell/$IMAGE:$VERSION-arm64v8 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-arm64v8
		
		docker tag bayrell/$IMAGE:$VERSION-arm32v7 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-arm32v7
		
		docker tag bayrell/$IMAGE:$VERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-amd64
		
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-amd64
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-arm32v7
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-arm64v8
		
		docker manifest create --amend \
			ghcr.io/bayrell-os/$IMAGE:$VERSION \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-arm32v7 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-arm64v8
		docker manifest push --purge ghcr.io/bayrell-os/$IMAGE:$VERSION
	;;

	all)
		$0 amd64
		$0 arm64v8
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {test|amd64|arm64v8|arm32v7|all}"
		RETVAL=1

esac

exit $RETVAL