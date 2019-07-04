FROM golang:alpine3.9 as builder

RUN apk add --no-cache git \
  && go get -u github.com/googlecloudplatform/gcsfuse \
  && mkdir -p /rootfs/usr/local/bin/ \
  && mv $GOPATH/bin/gcsfuse /usr/local/bin/gcsfuse \
  && apk del git

###
FROM dpage/pgadmin4:4.9
RUN apk add --no-cache supervisor fuse
COPY --from=builder /usr/local/bin/gcsfuse /usr/local/bin/gcsfuse
COPY supervisord.conf /supervisord.conf
ENTRYPOINT []
CMD ["supervisord", "--configuration", "/supervisord.conf"]

