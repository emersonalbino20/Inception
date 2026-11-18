#!/bin/bash

set -e

WP_PATH="/var/www/html"


if [ -f /run/secrets/db_password ]; then
    export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/credentials ]; then
    WP_ADMIN_PASSWORD=$(grep '^WP_ADMIN_PASSWORD=' /run/secrets/credentials | cut -d '=' -f2-)
    WP_USER_PASSWORD=$(grep '^WP_USER_PASSWORD=' /run/secrets/credentials | cut -d '=' -f2-)
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

if ! runuser -u www-data -- wp core is-installed --path="$WP_PATH"; then

    runuser -u www-data -- wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --path="$WP_PATH"

    runuser -u www-data -- wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=subscriber \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WP_PATH"
fi


exec "$@"
