FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm \
    php-mysqli \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc \
    php-soap \
    php-intl \
    php-zip \
    curl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html \
 && chown -R www-data:www-data /var/www/html

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN <<EOF
rm -rf /var/www/html/*
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
chown www-data:www-data /var/www/html/index.php
EOF

WORKDIR /var/www/html

CMD ["php-fpm8.2", "-F"]
