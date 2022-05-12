# Stage 1
FROM golang:1.18.2-alpine3.15 as builder
COPY . /app
RUN cd /app/cmd/radioauth/ && \
    go get -d -v && \
    GOOS=linux go build -v -a -o radioauth

# Stage 2
FROM alpine:3.15

LABEL org.opencontainers.image.authors="Aleksandr Aleksieienko mtsinput@gmail.com"

RUN mkdir -p /etc/radioauth

COPY --from=builder /app/cmd/radioauth/radioauth /etc/radioauth/

RUN apk add --no-cache curl tzdata bash jq

ENV TZ=Europe/Kiev \
    OAUTH_CLIENT_ID="radius_client" \
    OAUTH_CLIENT_SECRET="XXXX" \
    OAUTH_ISSUER="https://accounts.google.com" \
    OAUTH_CALLBACK_URL="http://your.server/auth/callback" \
    OAUTH_ACCOUNT_URL="https://myaccount.google.com/permissions" \
    ACCOUNT_STORE_PATH="/etc/radioauth/accounts" \
    RADIUS_SECRET="XXXX" \
    RADIUS_PORT=1812 \
    HTTP_PORT=5556

EXPOSE $RADIUS_PORT/udp
EXPOSE $HTTP_PORT

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]