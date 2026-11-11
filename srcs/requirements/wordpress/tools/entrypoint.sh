#!/bin/bash

set -e

WP_PATH="/var/www/html"

# if [ ! -f /var/www/html/index.php ]; then
#    cp -R /var/www/wordpress_temp/* /var/www/html/
#    chown -R www-data:www-data /var/www/html
#fi

if [ -f /run/secrets/db_password ]; then
    export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
	cat > "$WP_PATH/wp-config.php" << EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

\$table_prefix = '${WORDPRESS_TABLE_PREFIX:-wp_}';

${WP_SALTS}

define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
    define('ABSPATH', __DIR__ . '/');

require_once ABSPATH . 'wp-settings.php';
EOF
	find "$WP_PATH" -type d -exec chmod 750 {} \;
	find "$WP_PATH" -type f -exec chmod 640 {} \;
	chown -R www-data:www-data "$WP_PATH"
fi

exec "$@"
