#!/usr/bin/env bash

ALIASES_FILE=/vagrant/config/aliases
ALIASES_PATH=/etc/aliases

NGINX_CONF_FILE=/vagrant/config/nginx.conf
NGINX_CONF_PATH=/etc/nginx/nginx.conf
NGINX_SITES_AVAILABLE_PATH=/etc/nginx/sites-available
NGINX_SITES_ENABLED_PATH=/etc/nginx/sites-enabled

WWW_SRC=/vagrant/www/*
WWW_DEST=/var/safehomeelectric
SITE_CONF_FILE=/vagrant/config/site.conf
SITE_CONF_NAME=safehomeelectric
SITE_CONF_PATH=$NGINX_SITES_AVAILABLE_PATH/$SITE_CONF_NAME

## Upgrade packages
apt-get update
apt-get upgrade -y

## Install and configure sendmail
cp -fv $ALIASES_FILE $ALIASES_PATH
chmod 644 $ALIASES_PATH
chown root $ALIASES_PATH
chgrp root $ALIASES_PATH
apt-get install -y sendmail

## Install and configure nginx
apt-get install -y nginx
cp -fv $NGINX_CONF_FILE $NGINX_CONF_PATH
chmod 644 $NGINX_CONF_PATH
chown root $NGINX_CONF_PATH

## Create website content folder and copy static content
mkdir $WWW_DEST
cp -rv $WWW_SRC $WWW_DEST
chown -Rv root $WWW_DEST
chgrp -Rv root $WWW_DEST

# Clear any existing enabled sites
rm -rf $NGINX_SITES_ENABLED_PATH/*

# Enable the virtual site for nginx
cp -rv $SITE_CONF_FILE $SITE_CONF_PATH
chmod -Rv 644 $NGINX_CONF_PATH
chown -Rv root $NGINX_CONF_PATH
ln -sv $SITE_CONF_PATH $NGINX_SITES_ENABLED_PATH/$SITE_CONF_NAME
chmod -Rv 644 $SITE_CONF_PATH
chown -Rv root $SITE_CONF_PATH
service nginx restart