#!/bin/bash

set -e

config_file="/etc/radioauth/config.json"

# We start config file creation

cat <<EOF > $config_file
{
    "oauth_client_id": "$OAUTH_CLIENT_ID",
    "oauth_client_secret": "$OAUTH_CLIENT_SECRET",
    "oauth_issuer": "$OAUTH_ISSUER",
    "oauth_callback_url": "$OAUTH_CALLBACK_URL",
    "oauth_account_url": "$OAUTH_ACCOUNT_URL",
    "account_store_path": "$ACCOUNT_STORE_PATH",
    "radius_secret": "$RADIUS_SECRET",
    "http_port": $HTTP_PORT
}
EOF

mkdir -p $ACCOUNT_STORE_PATH

exec "$@"

set -m

/etc/radioauth/radioauth -config /etc/radioauth/config.json