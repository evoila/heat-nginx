#!/bin/bash

# Install nginx
apt-get update
apt-get install -y nginx-full

# Stop service
service nginx stop
