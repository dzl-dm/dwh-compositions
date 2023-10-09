
# Introduction
This composition will provide the CoMetaR project as multiple docker components from 1 docker composition.

[CoMetaR](https://github.com/dzl-dm/cometar) is a Collaborative Metadata Repository which was developed with medical concepts in mind

# Pre-requisites
We are assuming a clean, linux-based environment (git-bash and other windows based mechanisms should also work) with docker and docker compose plugin already installed and available to the user you are logged in as.

# Basic usage
The first step is to copy the essential files from our repo as templates, you will then edit these for you environment. Here we clone the repo (which is only small configuration files, but you may prefer to prepare everything on your desktop then copy over to the deployment system)
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
```

First choose your deployment type. For "CoMetaR" only:
```sh
cd dwh-compositions/cometar
```
Choose your flavour. We provide basic support for HTTPS with LetsEncrypt for CoMetaR via a third party NginX proxy or the composition for testing without HTTPS.  
* _.example_ - This version uses [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) for an unencrypted testing environment
* _.example.https_ - This version uses [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) and [acme-companion](https://github.com/nginx-proxy/acme-companion) projects to automate Lets Encrypt certificates

Then copy the chosen example files (this is so that you can freely run git pull without overwriting your own changes). The files which need copying are shown in the example commands below, where you may need to change `.example` to the flavour of your choice from above:
```sh
cp docker-compose.yml.example docker-compose.yml
cp .env.example .env
cp .env-proxy-cometar.example .env-proxy-cometar
cd config/proxy
cp location_dwh_cometar.example location_dwh_cometar
cd -
```

## Adjust for your environment
The directory has a `.env` file(s) which are used by docker to put environment variables into the containers. The exact `.env` file itself also allows the `docker compose` process to use the variables which can aid deployments while other env files are able to be passed through to the containers, but not read by docker compose. The `.env` provided covers a range of variables CoMetaR can use, most of which will not need changing. For setting up on a remote server, there should be 3 files where the remote server needs changing from `example.com` to whatever you want to use (including _'localhost'_ if testing locally) - change _'localhost'_ to your actual server name:
```sh
sed -i 's|example.com|localhost|g' docker-compose.yml
sed -i 's|example.com|localhost|g' .env-proxy-cometar
sed -i 's|example.com|localhost|g' config/proxy/location_dwh_cometar
```
These commands should affect the following variables:
* VIRTUAL_HOST - set to the server Fully Quallified Domain Name (FQDN). The edge proxy uses this - the vars are applied to the application proxy only
* LETSENCRYPT_HOST - set to the server Fully Quallified Domain Name (FQDN). The lets encrypt service uses this - the vars are applied to the application proxy only

It also overrides some NginX proxy config and updates a mounted file reference which NginX uses.

Please also consider changing the email address in the `docker-compose.yml` file to receive notification on your domain's certification status by changing:
```yaml
services:
  ...
  https-companion:
    ...
    environment:
      - DEFAULT_EMAIL=noreply@example.com
```

## Deploy containers
Once all the settings are done, you can deploy the containers to your system. This follows regular docker commands so no special setup should be needed. From the base directory of the deployment project (where you have the `docker-compose.yml` file), run the following:
```sh
docker compose up -d
```

After a short while, the composition of containers should be running and a basic CoMetaR installation available at the URL you have configured in the settings.


## NOTE: How the proxy works
I won't go into details here, look at the project's own documentation for that. The container keeps an eye on other containers and detects where certain ENV vars are set, then re-configures itself appropriately. That's why we have `.env-proxy-*` files for each service, as they have different routing requirements.

We also load more specific settings such as for authentication via mounted files.

### Upgrade the docker composition
When a newer version of CoMetaR is available and you want to upgrade, you will want to update the version reference in your `.env` file, then run this docker command:
```sh
docker compose up -d --force-recreate
```
> _NOTE:_ If you are referencing latest or build latest, you won't change the version reference, but you will need to force docker to pull the latest version with:
```sh
docker compose pull
## Then, as normal, run 'up':
docker compose up -d --force-recreate
```
You can check that the running containers are referencing the new images with:
```sh
docker ps -a
docker image ls
```
You'll see the version tag at the end of the image name, the ID should have changed if you are referencing (build-)latest (You can comare to image ID's with `docker image ls`)

# Post install and further details
Please see the README for the main project in github:
* [CoMetaR](https://github.com/dzl-dm/cometar)
