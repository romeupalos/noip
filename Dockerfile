FROM alpine:latest

WORKDIR /usr/src/app

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
