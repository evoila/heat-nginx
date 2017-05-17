#!/bin/bash

DELETE_DEFAULT_VHOST=${DELETE_DEFAULT_VHOST:-False}
DEFAULT_INDEX_PAGE=${DEFAULT_INDEX_PAGE}

# Deactivate default vhost
if [ "$DELETE_DEFAULT_VHOST" == "True" ]; then
  rm /etc/nginx/sites-enabled/default
else
  if [ ! -L /etc/nginx/sites-enabled/default ]; then
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
  fi
fi

# Write the default index page
if [ ! -z "$DEFAULT_INDEX_PAGE" ]; then
  cat <<EOF > /var/www/html/index.html
$DEFAULT_INDEX_PAGE
EOF
fi

service nginx restart
