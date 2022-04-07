FROM nginx:stable

RUN  apt-get update && \
      apt-get install -y cron certbot python3-certbot-nginx bash wget apache2-utils && \
      apt-get autoremove -y; apt-get clean && \
      rm -rf /var/lib/apt/lists/*

VOLUME /etc/letsencrypt

## Get config data and scripts
COPY bootstrap-proxy.sh /bootstrap.sh
COPY conf/ /etc/nginx/conf.d/
RUN rm /etc/nginx/conf.d/default.conf

## Setup env vars. These could be overriden, but in standard docker deployments will always be the same
ENV TZ=${TZ:-'Europe/Berlin'}
ENV DOMAIN_LIST=${BROWSER_FQDN:-localhost}
ENV CERTBOT_EMAIL=${ADMIN_EMAIL:-admin@localhost}
ENV USE_LE_SSL=${USE_LE_SSL:-False}
## Cometar env's
ENV BROWSER_FQDN=${BROWSER_FQDN:-localhost}
ENV COMETAR_WEB_SERVER=${WEB_SERVER:-http://cometar.web}
ENV COMETAR_GIT_SERVER=${GIT_SERVER:-http://cometar.git}
ENV COMETAR_BROWSER_GIT_PATH=${BROWSER_GIT_PATH:-/git}
ENV COMETAR_REST_SERVER=${REST_SERVER:-http://cometar.rest:5000}
ENV COMETAR_BROWSER_REST_PATH=${BROWSER_REST_PATH:-/rest}
ENV COMETAR_FUSEKI_SERVER=${FUSEKI_SERVER:-http://cometar.fuseki:3030}
ENV COMETAR_BROWSER_FUSEKI_PATH=${BROWSER_FUSEKI_PATH:-/fuseki}
## i2b2 env's
ENV I2B2_WEB_SERVER=${WEB_SERVER:-http://i2b2.web}
ENV I2B2_API_SERVER=${I2B2_API_SERVER:-http://i2b2.api:5000}

CMD [ "sh", "-c", "/bootstrap.sh && cron && nginx -g 'daemon off;'" ]
