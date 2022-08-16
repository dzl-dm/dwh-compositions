#!/bin/sh
## Configuration for NginX proxy
echo "---- BEGIN PROXY CONFIGURATION ----"

ORRIG_IFS=$IFS
IFS=,
## Build allow directives for nginx
if [ "$COMETAR_FUSEKI_ADMIN_ALLOW_RANGE" != "" ]; then
  echo "Setting fuseki admin allow range: ${COMETAR_FUSEKI_ADMIN_ALLOW_RANGE}"
  for range in $COMETAR_FUSEKI_ADMIN_ALLOW_RANGE; do
    TEMP_ALLOW_RANGE=$(echo "${TEMP_ALLOW_RANGE}allow ${range};")
  done
  export COMETAR_FUSEKI_ADMIN_ALLOW_RANGE="${TEMP_ALLOW_RANGE}"
  echo "NginX fuseki admin allow directive: ${COMETAR_FUSEKI_ADMIN_ALLOW_RANGE}"
fi
if [ "$COMETAR_REST_ALLOW_RANGE" != "" ]; then
  unset TEMP_ALLOW_RANGE
  echo "Setting rest allow range: ${COMETAR_REST_ALLOW_RANGE}"
  for range in $COMETAR_REST_ALLOW_RANGE; do
    TEMP_ALLOW_RANGE=$(echo "${TEMP_ALLOW_RANGE}allow ${range};")
  done
  export COMETAR_REST_ALLOW_RANGE="${TEMP_ALLOW_RANGE}"
  echo "NginX rest allow directive: ${COMETAR_REST_ALLOW_RANGE}"
fi
## Build allow directives for nginx
if [ "$I2B2_API_ALLOW_RANGE" != "" ]; then
  unset TEMP_ALLOW_RANGE
  echo "Setting rest allow range: ${I2B2_API_ALLOW_RANGE}"
  for range in $I2B2_API_ALLOW_RANGE; do
    TEMP_ALLOW_RANGE=$(echo "${TEMP_ALLOW_RANGE}allow ${range};")
  done
  export I2B2_API_ALLOW_RANGE="${TEMP_ALLOW_RANGE}"
  echo "NginX rest allow directive: ${I2B2_API_ALLOW_RANGE}"
fi
IFS=$ORIG_IFS
## Remove possible leading/trailing slashes
export COMETAR_GIT_PATH=$(echo ${COMETAR_GIT_PATH#/})
export COMETAR_GIT_PATH=$(echo ${COMETAR_GIT_PATH%/})
envsubst "\$BROWSER_FQDN \$COMETAR_FUSEKI_SERVER \$COMETAR_FUSEKI_ADMIN_ALLOW_RANGE \$COMETAR_GIT_SERVER \$COMETAR_GIT_ALLOW_RANGE \$COMETAR_REST_SERVER \$COMETAR_REST_ALLOW_RANGE \$COMETAR_WEB_SERVER \$I2B2_API_SERVER \$I2B2_API_ALLOW_RANGE \$I2B2_WEB_SERVER \$COMETAR_GIT_PATH" < /etc/nginx/conf.d/dwh-proxy.tmpl > /etc/nginx/conf.d/dwh.conf

## Create auth file if doesn't already exist
if [ ! -e /etc/nginx/auth/.htpasswd_git ]; then
  mkdir -p /etc/nginx/auth/
  touch /etc/nginx/auth/.htpasswd_git
fi

## Create auth file if doesn't already exist
if [ ! -e /etc/nginx/auth/.htpasswd_api ]; then
  mkdir -p /etc/nginx/auth/
  touch /etc/nginx/auth/.htpasswd_api
fi

## Initial run of certbot if its required (not localhost or already setup)
[ ${USE_LE_SSL} != True ] || [ ${DOMAIN_LIST} = localhost ] || [ -f /etc/letsencrypt/live/${BROWSER_FQDN}/fullchain.pem ] ||
      ( certbot certonly --standalone --agree-tos -m ${CERTBOT_EMAIL} -n -d ${DOMAIN_LIST} &&
      echo "PATH=$PATH" > /etc/cron.d/certbot-renew  &&
      echo "@weekly certbot renew --nginx >> /var/log/cron.log 2>&1" >>/etc/cron.d/certbot-renew &&
      crontab /etc/cron.d/certbot-renew ) ||
      echo "Something went wrong with the LetsEncrypt certificate setup, please check the details you've entered!"

## Disable ssl if file/link doesn't exist - it'll cause nginx to fail!
echo "Using FQDN: ${BROWSER_FQDN}"
[ -f /etc/letsencrypt/live/${BROWSER_FQDN}/fullchain.pem ] ||
[ -L /etc/letsencrypt/live/${BROWSER_FQDN}/fullchain.pem ] ||
  (sed -i -E 's/^(\s*listen\s*443.*|\s*listen\s*\[::\]:443.*)$/#&/' /etc/nginx/conf.d/dwh.conf &&
  sed -i -E 's/^(\s*ssl_certificate.*|\s*include \/etc\/nginx\/conf\.d\/ssl-settings\.inc.*)$/#&/' /etc/nginx/conf.d/dwh.conf)

echo "---- END PROXY CONFIGURATION ----"
