#!/bin/bash

NAME=${NAME}
CONFIG=${CONFIG}

# Make sure is a valid file name
NAME=$( echo $NAME | sed 's/[^a-zA-Z_-]/_/g' )

# Write config
FILE="/etc/nginx/sites-available/$NAME"
cat <<EOF > $FILE
$CONFIG
EOF

# Activate vhost
if [ ! -L "/etc/nginx/sites-enabled/$NAME" ]; then
  ln -s "$FILE" "/etc/nginx/sites-enabled/$NAME"
fi

service nginx restart
