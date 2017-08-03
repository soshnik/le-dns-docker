#!/bin/sh

# Get your API key from https://selectel.ruc
API_KEY=$(python -c "import json;config=open('/tmp/conf/config.json','r');print(json.load(config)['api_key']);config.close()")

# Get the Selectel zone id

ZONE_ID=$(curl -s -X GET "https://api.selectel.ru/domains/v1/" \
     -H     "domain_name: $CERTBOT_DOMAIN" \
     -H     "X-token: $API_KEY" \
     -H     "Content-Type: application/json" | python -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")

# Create TXT record
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"


RECORD_ID=$(curl -s -X POST "https://api.selectel.ru/domains/v1/$ZONE_ID/records/" \
     -H     "X-token: $API_KEY" \
     -H     "Content-Type: application/json" \
     --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","content":"'"$CERTBOT_VALIDATION"'","ttl":120}' \
             | python -c "import sys,json;print(json.load(sys.stdin)['id'])")


# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi
echo $ZONE_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/ZONE_ID
echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID

# Sleep to make sure the change has time to propagate over to DNS
sleep 25