#!/bin/bash
set -euxo pipefail

. functions.sh

function create_manifest() {
  docker run \
  --rm \
  -v $(pwd):/workdir \
  -w /workdir \
  weshigbee/manifest-tool \
  --username "$DOCKER_USER" \
  --password "$DOCKER_PASS" \
  push from-spec manifest-tmp.yml
}

if [[ "${TRAVIS_PULL_REQUEST:-}" == "false" ]] && [[ "${TRAVIS_BRANCH:-}" == "master" ]]; then
  VERSION=$(get_noip_duc)
  EXISTS=$(curl --silent -f -lSL https://hub.docker.com/v2/repositories/romeupalos/noip/tags | jq "[.results | .[] | .name == \"$VERSION\"] | any" -r)
  if [ "$EXISTS" == "false" ]; then
    # Manifest for latest
    cp manifest.yml manifest-tmp.yml
    sed -i -e 's/#TAG#/latest/g' manifest-tmp.yml
    sed -i -e "s/#VERSION#//g" manifest-tmp.yml
    create_manifest

    # Manifest for current version
    cp manifest.yml manifest-tmp.yml
    sed -i -e "s/#TAG#/$VERSION/g" manifest-tmp.yml
    sed -i -e "s/#VERSION#/${VERSION}-/g" manifest-tmp.yml
    create_manifest
  fi
fi
