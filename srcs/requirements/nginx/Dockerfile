FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx-selfsigned.key \
        -out /etc/nginx/ssl/nginx-selfsigned.crt \
        -subj "/C=AO/ST=Luanda/L=Luanda/O=42/OU=Inception/CN=ealbino.42.fr" \
        -addext "subjectAltName=DNS:ealbino.42.fr"

COPY conf/default /etc/nginx/sites-available/default

ENTRYPOINT ["nginx"]

CMD ["-g", "daemon off;"]
