# Introduction
Its also possible to deploy a proxy and application(s) with loose integration. Here we outline how with example proxy docker definitions alongside instructions and tips to configure the docker applications to be accessible through the proxy.

## Preparing the proxy
The main aim of the proxy is to provide https termination, so we will not explain how to run it without, although this is possible if desired. We outline the 2 following modes of operation:
* Using LetsEncrypt for automatic certificates and renewals
* Using traditional certificates from your preferred provider, manually presented to the proxy
In each case, the deployment should be in its own directory, not in the same directory as your application(s)

### Using LetsEncrypt
The definition itself requires no changes, we recommend the following process...

[If working in a clone of the repository] Copy the appropriate example definition with matching `.env` file:
```sh
cp docker-compose_letsencrypt.yml docker-compose.yml
cp .letsencrypt.env .env
```
[If you have application from other repositories] Download the two files from github. eg. From your "docker-compositions" directory (the parent of you application directory):
```sh
mkdir proxy
wget -o proxy/docker-compose.yml https://raw.githubusercontent.com/dzl-dm/dwh-compositions/master/proxy-separate-application/docker-compose_letsencrypt.yml
wget -o proxy/.env https://raw.githubusercontent.com/dzl-dm/dwh-compositions/master/proxy-separate-application/.letsencrypt.env
```
Now you only need to edit the `.env` file with your email address and the desired version of the proxy components (see [docker hub](https://hub.docker.com/u/nginxproxy) ("nginx-proxy" and "acme-companion")).

> NOTE: The directory "proxy" can actually be placed anywhere and called anything, but it will affect the network name prefix needed later.

### Using manual certificates
Maybe you work in more stringent conditions than domain verification or for other reasons have a certificate supplied by other means. Then we can let the proxy use this certificate through the following process.

> NOTE: Work in progress

[If working in a clone of the repository] Copy the appropriate example definition with matching `.env` file:
```sh
cp docker-compose_manual.yml docker-compose.yml
cp .manual.env .env
```
[If you have application from other repositories] Download the two files from github. eg. From your "docker-compositions" directory (the parent of you application directory):
```sh
mkdir proxy
wget -o proxy/docker-compose.yml https://raw.githubusercontent.com/dzl-dm/dwh-compositions/master/proxy-separate-application/docker-compose_manual.yml
wget -o proxy/.env https://raw.githubusercontent.com/dzl-dm/dwh-compositions/master/proxy-separate-application/.manual.env
```

> NOTE: The directory "proxy" can actually be placed anywhere and called anything, but it will affect the network name prefix needed later.

Now you may want to edit the `.env` file with your desired version of the proxy (see [docker hub](https://hub.docker.com/r/nginxproxy/nginx-proxy/tags)).
You may also want to edit the `docker-compose.yml` file to adjust the directory used for certificates on the hosting server (the container directory must stay the same). eg:
```yaml
...
services:
  ## Third-party proxy
  https-proxy:
    ...
    volumes:
      ## Let user mount their certificates manually
      - ${PWD}/certs/:/etc/nginx/certs:ro
    ...
```

The proxy will use the domain name as the filename of the key and certificate, [see documentation](https://hub.docker.com/r/nginxproxy/nginx-proxy/tags). This means that you must upload your key and certificate (the full chain of root, intermediates and for your specific domain) to the server in the path defined in the `docker-compose.yml`, with names like:
* my.domain.tld.key
* my.domain.tld.crt
* _OPTIONAL:_ my.domain.tld.chain.pem

> NOTE: See NginX [docs on chains](https://nginx.org/en/docs/http/configuring_https_servers.html#chains) for more details about exactly how to prepare the certificate file. Your IT department should also be able provide you with the relevant files (certificate and chain/bundle) and even instructions for using with NginX, or the prepared certificate file.

## Adjusting your application(s)
Independent of the certificate method (Lets Encrypt or Manual), there is a little work to do here and it must be done before deploying the proxy. You will need a short amount of downtime to redeploy everything in the right order after defining the new configurations.

The edits can be limited to the `docker-compose.yml` for each application which you are deploying, we will outline the changes with this assumption (The alternative is to move some of the changes into `.env` files, but you must make sure they only affect the appropriate container!)

> NOTE: The elipses `...` are not to be applied literally, they only mean that this is a snippet of the file, other lines should (usually) be left alone

Ensure the proxy can connect to your application:
```yml
...
networks:
  ## The network name comes from the `docker-compose.yml` of the proxy, but is prefixed with the directory of the proxy composition, so it might be different for you!
  proxy_edge-proxy:
    external: true
  ...
  ## If your application doesn't already have a network defined, that also needs to be added (you can choose the name, it needs to match later)
  application-backend:
...
```
> NOTE: Check docker networks with `docker network ls`

Your application shouldn't map ports anymore, the proxy does that, so the application needs only to accept connections from the proxy. In the definition of the service which is/was-previously exposing ports, remove lines like this:
```yml
...
services:
  my-app:
    ...
    ## Remove only this "ports" section
    ports:
      - 80:80
      - 443:443
    ...
```
and add lines like this:
```yml
...
services:
  my-app:
    ...
    networks:
      - proxy_edge-proxy
      ...
      ## The service will still need to be in the same network as other parts of the application (usually the backend), so ensure you also have a backend network defined.
      - application-backend
    environment:
      ## These new variables are read by the proxy and used to configure the https certificate and routing
      ## VIRTUAL_HOST=str: fqdn for the proxy where the web application should be accessible (eg. app.company.com)
      - VIRTUAL_HOST=example.com
      ## LETSENCRYPT_HOST=str: Tells the proxy and its companion to generate and manage an HTTPS certificate for you (usually same as VIRTUAL_HOST)
      - LETSENCRYPT_HOST=example.com
      ## [VIRTUAL_PATH]=str: [optional] path to signal when to redirect to this container
      - VIRTUAL_PATH=/app-name
      ## [VIRTUAL_DEST]=str: [optional] path on the destination server
      - VIRTUAL_DEST=/
      ...
```
Then ensure the application can still communicate amongst its own components, bind each service component with the application network:
```yml
...
services:
  <each-app-service>:
    ...
    networks:
      ## Each component of the application (usually) needs to be in the same network
      - application-backend
```

### Re-deploying
Now you should have a 2 or more `docker-compose.yml` files, each in their own directory:
* 1 for the proxy
* 1 for each application (CoMetaR, i2b2, etc)
eg:
```
docker-compositions/
├── cometar/
│   ├── docker-compose.yml
│   ├── .env
│   └── <other files and directories>
└── proxy/
    ├── docker-compose.yml
    └── .env
```

You should ensure no containers are running. eg:
```sh
cd cometar
docker compose down
## The volumes (and therefore data) remain unaffected
```
Then you can (re)start both the application and proxy. eg:
```sh
cd cometar
docker compose up -d
cd ../proxy
docker compose up -d
```
> NOTE: The order doesn't actually matter, the proxy will monitor docker for started and stopped containers and update itself on the fly

Now you can check the logs to see if the proxy or acme-companion are having any problems:
```sh
docker logs --tail 45 -f main.acme
docker logs --tail 45 -f main.proxy
```
