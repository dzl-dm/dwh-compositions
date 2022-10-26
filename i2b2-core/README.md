
# Introduction
This composition will provide the i2b2 project as 3 docker components under 1 composition.

[i2b2](https://www.i2b2.org/) is a community maintained project designed for "Informatics for Integrating Biology and the Bedside"

# Pre-requisites
We are assuming a clean, linux-based environment (git-bash and other windows based mechanisms should also work) with docker already installed and available to the user you are logged in as.

# Basic usage
The first step is to copy the essential files from our repo as templates, these will then be edited for you environment (you may prefer to prepare everything on your desktop then copy over to the deployment system)
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
```

First choose your deployment type. For "i2b2" only:
```sh
cd dwh-compositions/i2b2-core
```
Then you will need to make a copy of the user editable files (this is so that you can freely run git pull without overwriting your own changes). The 3 files which need copying are shown in the example commands below - you could of course use another method of making these copies:
```sh
cp docker-compose.yml.example docker-compose.yml
cp .env.example .env
cp secrets/i2b2-secrets.example secrets/i2b2-secrets
```

We strongly recommend changing the passwords stored in `./secrets/i2b2-secrets` before deployment. Additionally, you must [change the user passwords](https://github.com/dzl-dm/i2b2#change-default-passwords) for i2b2 once the application is running 

## Adjust your .env
The directory has a `.env` file which is used by docker to put environment variables into the containers. It also allows the `docker-compose` process to use them which can aid deployments. The `.env` provided covers a range of variables i2b2 can use, most of which will not need changing. For setting up on a remote server, the relevant fields should be changed.

## Deploy containers
Once all the settings are done, you can deploy the containers to your system. This follows regular docker commands so no special setup should be needed. From the base directory of the project (where you have the `docker-compose.yml` file), run the following:
```sh
docker-compose up -d
```

After a short while, the composition of containers should be running and a basic i2b2 (by **default**: http://localhost/webclient/) installation available at the URL in the settings. Demo data should be loaded if you set that option in `.env`

# Post install and further details
Please see the README's for the two respective projects in github:
* [i2b2](https://github.com/dzl-dm/i2b2)

## Divergence
There are no specific changes in behaviour from i2b2's own docker deployment, however we don't guarantee it will respond in exactly the same way to environment variables which are set.
