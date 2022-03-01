
# Introduction
This composition will provide both the CoMetaR and i2b2 projects on one server.

[i2b2](https://www.i2b2.org/) is a community maintained project designed for "Informatics for Integrating Biology and the Bedside"

[CoMetaR](https://github.com/dzl-dm/cometar) is a Collaborative Metadata Repository which was developed with medical concepts in mind

# Pre-requisites
We are assuming a clean, linux-based environment (git-bash and other windows based mechanisms should also work) with docker already installed and available to the user you are logged in as.
Tested docker version: 20.10.11

# Basic usage
The first step is to copy the essential files from our repo as templates, these will then be edited for you environment (you may prefer to prepare everything on your desktop then copy over to the deployment system)
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
```

Out of the box, this should deploy a functional installation of both i2b2 and cometar, simply by running this in the directory with your `docker-compose.yml` and `.env*` files:
```sh
docker-compose up -d
```

We strongly recommend changing the passwords stored in `.env-secrets` before deployment. Additionally, you must [change the user passwords](#change-default-passwords) for i2b2 once the application is running 

## Adjust your .env
The directory has a `.env` file which is used by docker to put environment variables into the containers. It also allows the `docker-compose` process to use them which can aid deployments. The `.env` provided covers a range of variables i2b2 and CoMetaR can use, most of which will not need changing. For setting up on a remote server, the relevant fields should be changed.

## Deploy containers
Once all the settings are done, you can deploy the containers to your system. This follows regular docker commands so no special setup should be needed. From the base directory of the project (where you have the `docker-compose.yml` file), run the following:
```sh
docker-compose up -d
```

After a short while, the composition of containers should be running and a basic i2b2 (by **default**: http://localhost/webclient/) and CoMetaR (by **default**: http://localhost/) installation available at the URL in the settings. Demo data should be loaded if you set that option in `.env`

# Post install and further details
Please see the README's for the two respective projects in github:
* [i2b2](https://github.com/dzl-dm/i2b2)
* [CoMetaR](https://github.com/dzl-dm/cometar)
