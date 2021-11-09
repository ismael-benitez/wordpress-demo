#!/usr/bin/env sh

WPPATH=/var/www/html

# Import WP TESTS
cd $WPPATH
curl -O https://raw.githubusercontent.com/manovotny/wptest/master/wptest.xml
wp core install --url=localhost:8000 --title="The makefile demo" --admin_user=demo --admin_password=demo --admin_email=demo@email.com --allow-root
wp plugin install wordpress-importer --activate --allow-root
wp import wptest.xml --authors=create --allow-root
rm wptest.xml