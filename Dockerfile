ARG BUILD_DATE
ARG VCS_REF
ARG ARCH
ARG QEMU

# This is a multi stage Dockefile.
# This stage will be discarded after the build
FROM $ARCH/alpine:latest as intermediate

WORKDIR /usr/src/app

ADD $QEMU /usr/bin

COPY . /usr/src/app

RUN apk add --no-cache make g++ ca-certificates wget &&  \
    echo "Building on arch: $(uname -m)" && \
    cd $(find . -maxdepth 1 -mindepth 1 -type d) && \
    make && \
    cp noip2 /usr/bin

FROM $ARCH/alpine:latest

# Build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="NoIP" \
    org.label-schema.description="Dynamic DNS client to update NoIP services." \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/romeupalos/noip" \
    org.label-schema.license="MIT" \
    org.label-schema.schema-version="1.0"

COPY ./docker-entry.sh /bin/

COPY --from=intermediate /usr/bin/noip2 /usr/bin/

ENTRYPOINT [ "/bin/docker-entry.sh" ]
