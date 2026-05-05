FROM alpine:latest
RUN apk add --no-cache curl
COPY discord-notify.sh /notify.sh
RUN chmod +x /notify.sh
ENTRYPOINT ["/notify.sh"]