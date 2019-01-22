FROM alpine:latest

WORKDIR /usr/src/app

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="NoIP" \
      org.label-schema.description="Dynamic DNS client to update NoIP services." \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/romeupalos/noip" \
      org.label-schema.license="MIT" \
      org.label-schema.schema-version="1.0"

RUN apk add --no-cache make g++ ca-certificates wget &&  \
    wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && \
    update-ca-certificates && \
    tar zxvf noip-duc-linux.tar.gz && \
    cd $(find . -maxdepth 1 -mindepth 1 -type d) && \
    make && \
    cp noip2 /usr/bin && \
    cd .. && \
    rm -rf * && \
    apk del make g++ ca-certificates wget

CMD [ "/usr/bin/noip2" ]
