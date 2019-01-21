# add docker image
apk add --no-cache docker && \
# build image
docker build -t romeupalos/noip:$OS-$ARCH . && \
# test image
NOIP_VERSION=$(docker run --rm \
  romeupalos/noip \
  /usr/bin/noip2 -h 2>&1 |
  grep -E "^Version" |
  cut -d"-" -f2) && \

docker tag romeupalos/noip:$ARCH romeupalos/noip:$NOIP_VERSION-$OS-$ARCH
# print version and architecture for logging purposes
echo Built version: $NOIP_VERSION && \
uname -a && \

#Deploy to Docker Hub
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]] && [[ "$TRAVIS_BRANCH" == "master" ]]; then
  echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin && \
  docker push romeupalos/noip
fi
