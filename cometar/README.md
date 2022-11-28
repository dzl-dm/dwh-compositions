
# Introduction
This composition will provide the CoMetaR project as multiple docker components from 1 docker composition.

[CoMetaR](https://github.com/dzl-dm/cometar) is a Collaborative Metadata Repository which was developed with medical concepts in mind

# Pre-requisites
We are assuming a clean, linux-based environment (git-bash and other windows based mechanisms should also work) with docker and docker plugin already installed and available to the user you are logged in as.

# Basic usage
The first step is to copy the essential files from our repo as templates, these will then be edited for you environment. Here we clone the repo (which is only small configuration files, but you may prefer to prepare everything on your desktop then copy over to the deployment system)
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
```

First choose your deployment type. For "CoMetaR" only:
```sh
cd dwh-compositions/cometar
```
Then choose your flavour. These flavours are aimed to help deploy CoMetaR in various environments.  
Currently we only offer the standalone HTTPS terminating version, but this is likely to be exteded in the future.  
* _example_ - Work in Progress: This version uses [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) for an unencrypted testing environment
* _example-https_ - This version uses [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) and [acme-companion](https://github.com/nginx-proxy/acme-companion) projects to automate Lets Encrypt certificates

Then you will need to make a copy of the user editable files (this is so that you can freely run git pull without overwriting your own changes). The files which need copying are shown in the example commands below where you may need to change `example` to the flavour of your choice from above:
```sh
cp docker-compose.yml.example docker-compose.yml
cp .env.example .env
cp .env-proxy.example .env-proxy
```

## Adjust your .env
The directory has a `.env` file(s) which are used by docker to put environment variables into the containers. The .env file itself also allows the `docker compose` process to use the variables which can aid deployments. The `.env` provided covers a range of variables CoMetaR can use, most of which will not need changing. For setting up on a remote server, the relevant fields should be changed, such as:
* WEB_FQDN and BROWSER_FQDN - set to the server Fully Quallified Domain Name (FQDN). CoMetaR application uses these variables
* VIRTUAL_HOST - set to the server Fully Quallified Domain Name (FQDN). The edge proxy uses this - the vars are applied to the application proxy only
* LETSENCRYPT_HOST - set to the server Fully Quallified Domain Name (FQDN). The lets encrypt service uses this - the vars are applied to the application proxy only

## Deploy containers
Once all the settings are done, you can deploy the containers to your system. This follows regular docker commands so no special setup should be needed. From the base directory of the project (where you have the `docker-compose.yml` file), run the following:
```sh
docker compose up -d
```

After a short while, the composition of containers should be running and a basic CoMetaR installation available at the URL you have configured in the settings.

# Post install and further details
Please see the README for the main project in github:
* [CoMetaR](https://github.com/dzl-dm/cometar)
