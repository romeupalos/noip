#!/bin/bash
set -euxo pipefail

function get_noip_duc() {
  wget -c http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
  tar zxf noip-duc-linux.tar.gz
  echo $(find . -maxdepth 1 -mindepth 1 -type d -name 'noip*' | cut -d "-" -f2-)
}

function get_arch() {
  local arch
  case ${1} in
    x86_64)
      arch="amd64"
      ;;
    ppc64le)
      arch="ppc64le"
      ;;
    s390x)
      arch="s390x"
      ;;
    aarch64)
      arch="arm64v8"
      ;;
    arm)
      arch="arm32v6"
      ;;
    i386)
      arch="i386"
      ;;
    *)
      echo "$0 does not support architecture ${1} ... aborting"
      exit 1
      ;;
  esac

  echo "${arch}"
}

docker run \
  --rm \
  --privileged \
  multiarch/qemu-user-static:register \
  --reset

VERSION=$(get_noip_duc)

# build image
docker build \
  -t romeupalos/noip:${VERSION}-$(get_arch "${ARCH}") \
  --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --build-arg ARCH=$(get_arch "${ARCH}") \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  --build-arg QEMU=qemu-${ARCH}-static \
  .

# test image
NOIP_VERSION=$(docker run --rm \
  -v $(pwd)/qemu-${ARCH}-static:/usr/bin/qemu-${ARCH}-static \
  romeupalos/noip:${VERSION}-$(get_arch "$ARCH") \
  /usr/bin/noip2 -h 2>&1 |
  grep -E "^Version" |
  cut -d"-" -f2)

docker tag \
  romeupalos/noip:${VERSION}-$(get_arch "$ARCH") \
  romeupalos/noip:$(get_arch "$ARCH")

if [[ "${TRAVIS_PULL_REQUEST:-}" == "false" ]] && [[ "${TRAVIS_BRANCH:-}" == "master" ]]; then
  EXISTS=$(curl --silent -f -lSL https://hub.docker.com/v2/repositories/romeupalos/noip/tags | jq "[.results | .[] | .name == \"$VERSION\"] | any" -r)
  if [ "$EXISTS" == "false" ]; then
    echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
    docker push romeupalos/noip
  fi
fi
