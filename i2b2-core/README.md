
# Introduction
This composition will provide the i2b2 project as multiple docker components under 1 composition. Optionally a 2-component automatic https proxy can also be deployed.

[i2b2](https://www.i2b2.org/) is a community maintained project designed for "Informatics for Integrating Biology and the Bedside"

# Pre-requisites
We are assuming a clean, linux-based environment with docker already installed (WSL, git-bash and other windows based mechanisms should also work) and available to the user you are logged in as.

# Basic usage
This composition should be treated as a variant of what is offered in the [i2b2-core](https://github.com/dzl-dm/i2b2-core) repository. As such, the documentation there applies here. Additional and/or variations to that documentation are detailed below. To use this composition, clone this repo (or download only this directory if you prefer) instead of the i2b2-core repo, but then continue to follow the i2b2-core documentation, except where this README overrides it.

You cannot clone only this sub-directory of the dwh-compositions repo, if you prefer to clone, you must clone the whole repo and navigate to this directory. eg:
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
cd dwh-compositions/i2b2-core
```
> _NOTE:_ If you prefer to select a specific commit, parhaps a tagged version, or a test branch, then you can refer to the [upgrade section](#upgrading). You don't need to worry about comparing the files, but these instructions may not fully reflect what you want to work with.

## Enabling https
We have provided 2 example versions of the composition, one which provides only the i2b2 application and one which also provides an https terminating proxy. If your infrastructure already provides you with an https proxy, then you should choose the version without `-https` in the example filenames.

When deploying the `*-https` version, you will find 2 additional containers being deployed:
1. NginX proxy - Through the `docker-compose` setup, this will proxy requests to the application.
1. ACME companion - Through the `env-proxy` settings, this will provide an SSL certificate via LetsEncrypt.

Together, these make your i2b2-core application available over https. Although this is largely automated, there are some small additional configurations to make in addition to following the i2b2-core setup documentation:
* Set `.env` variable: ssl_proxy=true
* Also set these in your `.env`, the defaults in `.env.example-https` can be adjusted if desired:
    * NGINX_PROXY_VERSION
    * ACME_COMPANION_VERSION
* Copy and set the variables in the additional `.env-proxy` file from `.env-proxy.example-https`, the values will be specific to your environment. These are targeted to i2b2-web only so that the proxy system can detect them and know which contianer to proxy which hostname to:
    * VIRTUAL_HOST - Purely for the proxy to respond and direct the correct hostname, which is the address users will use to access the website
    * LETSENCRYPT_HOST - This is for SSL certificate generation, usually you want it to be the same as 'VIRTUAL_HOST'
* An additional variable lies within the `docker-compose.yml` file which should be updated to your email address (assuming you are administering this service!). It is sent to LetsEncrypt when requesting the certificate. It allows them to inform you if the certificate is expiring or there are any other developments that may affect your certificate.
```yaml
services:
  https-companion:
    environment:
    - DEFAULT_EMAIL=<Real E-Mail address>
```

Once these changes (together with those in the i2b2-core documentation) are made, you should be ready to deploy.

# Upgrading
```sh
## First clone the repo
git clone https://github.com/dzl-dm/dwh-compositions.git
## Or ensure you have the up-to-date repo
git fetch --all --tags
## Checkout the new tag/branch/commit you want to upgrade to
git checkout <tag>
## eg git checkout v0.2.4
## Navigate to the directory with your composition. eg
cd dwh-compositions/i2b2-core
## Compare the files which you had initally copied from examples with their new versions eg
diff .env .env.example-https
## Obviously any environment specific changes (values) which you have already made will be different, and mostly should remain so. Any version variables should likely be changed though. 
## You should also look out for new variables and add them to your .env* files
## Also check the docker-compose.yml as the deployment structure could have changed too eg:
diff docker-compose.yml docker-compose.yml.example
## It's possible the database requires some changes. We often try to provide a script to help make these changes.
## Once all the changes are made, you can re-deploy the composition
docker compose down
docker compose pull
docker compose up -d --force-recreate
```
> _NOTE:_ Rolling back to a previous version would mean un-doing any changes made in this section and re-deploying again. Such as reverting the version. Usually there are not too many changes, but saving your configuration in a version control system could be beneficial here.
