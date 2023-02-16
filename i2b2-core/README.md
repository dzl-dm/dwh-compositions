
# Introduction
This composition will provide the i2b2 project as multiple docker components under 1 composition. Optionally a 2-component automatic https proxy can also be deployed.

[i2b2](https://www.i2b2.org/) is a community maintained project designed for "Informatics for Integrating Biology and the Bedside"

# Pre-requisites
We are assuming a clean, linux-based environment with docker already installed (WSL, git-bash and other windows based mechanisms should also work) and available to the user you are logged in as.

# Basic usage
This composition should be treated as a variant of what is offered in the [i2b2-core](https://github.com/dzl-dm/i2b2-core) repository. As such, the documentation there applies here. Additional and/or variations to that documentation are detailed below. To use this composition, clone this repo (or download only this directory if you prefer), and then continue to follow the i2b2-core documentation.

When deploying the `*-https` version, you will find 2 additional containers being deployed:
1. NginX proxy - Through the `docker-compose` setup, this will proxy requests to the application.
1. ACME companion - Through the `env-proxy` settings, this will provide an SSL certificate via LetsEncrypt.

Together, these make your i2b2-core application available over https. Although this is largely automated, there are some small additional configurations to make while following the setup documentation:
* Set `.env` variable: ssl_proxy=true
* Also set these in your `.env`, the defaults in `.env.example-https` can be adjusted if desired:
    * NGINX_PROXY_VERSION
    * ACME_COMPANION_VERSION
* Copy and set the variables in the additional `.env-proxy` file, the values will be specific to your environment:
    * VIRTUAL_HOST
    * LETSENCRYPT_HOST
