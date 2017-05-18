#!/bin/bash

DELETE_DEFAULT_VHOST=${DELETE_DEFAULT_VHOST:-False}
DEFAULT_INDEX_PAGE=${DEFAULT_INDEX_PAGE}

mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

cat <<EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
include /usr/share/nginx/modules/*.conf;
events {
    worker_connections 1024;
}
http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
    include /etc/nginx/conf.d/*;
    include /etc/nginx/sites-enabled/*;
    server_names_hash_bucket_size 64;
}
EOF

cat <<EOF > /etc/nginx/sites-available/default
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  _;
    root         /usr/share/nginx/html;
    location / {
    }
    error_page 404 /404.html;
        location = /40x.html {
    }
    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }
}
EOF

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
  cat <<EOF > /usr/share/nginx/html/index.html
$DEFAULT_INDEX_PAGE
EOF
fi

service nginx restart

# Enable Nginx to start when your system boots
systemctl enable nginx
