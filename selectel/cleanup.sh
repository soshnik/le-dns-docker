#!/bin/sh

# Get your API key from https://selectel.ru
API_KEY=$(python -c "import json;config=open('/tmp/conf/config.json','r');print(json.load(config)['api_key']);config.close()")


if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/ZONE_ID ]; then
        ZONE_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/ZONE_ID)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/ZONE_ID
fi

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi

# Remove the challenge TXT record from the zone
if [ -n "${ZONE_ID}" ]; then
    if [ -n "${RECORD_ID}" ]; then
        curl -s -X DELETE "https://api.selectel.ru/domains/v1/$ZONE_ID/records/$RECORD_ID" \
                -H "X-token: $API_KEY" \
                -H "Content-Type: application/json"
    fi
fi