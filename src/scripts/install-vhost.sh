#!/bin/bash

NAME=${NAME}
CONFIG=${CONFIG}

# Make sure is a valid file name
NAME=$( echo $NAME | sed 's/[^a-zA-Z_-]/_/g' )

# Variables to be used within config
PRIMARY_ADDR=$(ip addr show dev `ip route show | grep -E "^default" | awk '{ print $5 }'` | grep "inet " | awk '{ print $2 }' | cut -d "/" -f1 | head -n1)

# Eval config to replace variables
RESULTING_CONFIG=$(eval echo \""$CONFIG"\")

# Write config
FILE="/etc/nginx/sites-available/$NAME"
cat <<EOF > $FILE
$RESULTING_CONFIG
EOF

# Activate vhost
if [ ! -L "/etc/nginx/sites-enabled/$NAME" ]; then
  ln -s "$FILE" "/etc/nginx/sites-enabled/$NAME"
fi

service nginx restart
