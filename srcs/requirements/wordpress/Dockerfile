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
    wget \
    unzip \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html /var/www/wordpress_temp

RUN curl -o /tmp/wordpress.tar.gz -sSL https://wordpress.org/latest.tar.gz \
 && tar -xzf /tmp/wordpress.tar.gz -C /var/www/wordpress_temp --strip-components=1 \
 && rm /tmp/wordpress.tar.gz \
 && chown -R www-data:www-data /var/www/wordpress_temp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]
