
# Introduction
This composition will provide the i2b2 service (as multiple docker components) and the i2b2-uploader service (as multiple docker components) under 1 composition.

[i2b2](https://www.i2b2.org/) is a community maintained project designed for "Informatics for Integrating Biology and the Bedside"  
The _i2b2-uploader_ is 2 git projects; the [API](https://github.com/dzl-dm/i2b2-upload-api) and the [Processor](https://github.com/dzl-dm/i2b2-upload-processor). They are both custom built components by the DZL which allow a fhir-bundle of patient data to be inserted to i2b2. See each component for more details.

# Pre-requisites
We are assuming a clean, linux-based environment with docker already installed (WSL, git-bash and other windows based mechanisms should also work) and available to the user you are logged in as.

# Basic usage
To use this composition, clone this repo (or download only this directory if you prefer) instead of the individual components.

You cannot clone only this sub-directory of the dwh-compositions repo, if you prefer to clone, you must clone the whole repo and navigate to this directory. eg:
```sh
git clone https://github.com/dzl-dm/dwh-compositions.git
cd dwh-compositions/i2b2-core_uploader
```

After following this guide, the i2b2 web query interface will be available at: http://localhost/webclient with a default, pre-filled demo login.
The api is presented under http://localhost:8000
These can be adjusted for testing (eg if you can't use protected ports like 80). They would also be best set differently for a production server.

Then there are 4 basic steps to get a test project up and running in your environment after downloading this directory.
## Configure the services
We provide sample config files here with defaults that work out of the box. This isn't suitable for production servers or even every test environment, but its a good starting point even if it doesn't fully work.

## Deploy the services
Once the configuration is complete, deploy the composition as below. If you make changes you can re-deploy with the same command.
```sh
## Optionally ensure database volume is removed for a clean start:
docker volume rm i2b2-core_uploader_i2b2-db
## Deploy:
docker compose up -d --force-recreate --build --remove-orphans
## Shutdown:
docker compose down
```
## Load the metadata
A basic set of concepts are available for testing. Once the database container is running, the following shell script loads the data which is mounted by the docker compose file:
```sh
./testing/load-meta-data.sh
```

## Push test data
This service composition also includes test data under _testing_. You can substitute it with your own data if you like.
Here is how to work with the test data when you do not have/want to use a compatible client. Instead you can use `curl` for all the interactions.

### List datasources
```sh
curl -v -X GET -H "x-api-key: ChangeMe" http://localhost:8000/datasource
```

### Upload new (or existing) datasource
```sh
curl -v -X PUT -H "x-api-key: ChangeMe" http://localhost:8000/datasource/test/fhir-bundle -F "fhir_bundle=@./testing/sample-datasource.xml"
```

### Process uploaded datasource
```sh
curl -v -X POST -H "x-api-key: ChangeMe" http://localhost:8000/datasource/test/etl
```

### Check status of specific datasource
```sh
curl -v -X GET -H "x-api-key: ChangeMe" http://localhost:8000/datasource/test/etl
```

### Check info/error for specific datasource
```sh
curl -v -X GET -H "x-api-key: ChangeMe" http://localhost:8000/datasource/test/etl/info
curl -v -X GET -H "x-api-key: ChangeMe" http://localhost:8000/datasource/test/etl/error
```

### Delete specific datasource
```sh
curl -v -X DELETE -H "x-api-key: ChangeMe" http://localhost:8000/datasource/test
```
