
# Introduction
This composition will provide the CoMetaR project as 5 docker components from 1 docker composition.

[CoMetaR](https://github.com/dzl-dm/cometar) is a Collaborative Metadata Repository which was developed with medical concepts in mind

# Pre-requisites
We are assuming a clean, linux-based environment (git-bash and other windows based mechanisms should also work) with docker already installed and available to the user you are logged in as.

# Basic usage
The first step is to copy the essential files from our repo as templates, these will then be edited for you environment (you may prefer to prepare everything on your desktop then copy over to the deployment system)
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
```

First choose your deployment type. For "CoMetaR" only:
```sh
cd dwh-compositions/cometar
```
Then you will need to make a copy of the user editable files (this is so that you can freely run git pull without overwriting your own changes). The 2 files which need copying are shown in the example commands below - you could of course use another method of making these copies:
```sh
cp docker-compose.yml.example docker-compose.yml
cp .env.example .env
```

## Adjust your .env
The directory has a `.env` file which is used by docker to put environment variables into the containers. It also allows the `docker-compose` process to use them which can aid deployments. The `.env` provided covers a range of variables i2b2 and CoMetaR can use, most of which will not need changing. For setting up on a remote server, the relevant fields should be changed.

## Deploy containers
Once all the settings are done, you can deploy the containers to your system. This follows regular docker commands so no special setup should be needed. From the base directory of the project (where you have the `docker-compose.yml` file), run the following:
```sh
docker-compose up -d
```

After a short while, the composition of containers should be running and a basic CoMetaR (by **default**: http://localhost/) installation available at the URL in the settings.

# Post install and further details
Please see the README for the main project in github:
* [CoMetaR](https://github.com/dzl-dm/cometar)
