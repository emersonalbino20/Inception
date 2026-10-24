#!/bin/bash

if [ ! -f /var/www/html/index.php ]; then
    cp -R /var/www/wordpress_temp/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

exec "$@"