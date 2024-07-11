
# Introduction
The Data Warehouse compositions are intended to help users deploy a data warehouse utilising i2b2 for patient oriented medical data and CoMetaR for metadata about medical concepts and parameters. The deployment options allow the user to select which tools are included.

[i2b2](https://www.i2b2.org/) is a community maintained project designed for "Informatics for Integrating Biology and the Bedside"

[CoMetaR](https://github.com/dzl-dm/cometar) is a Collaborative Metadata Repository which was developed with medical concepts in mind

To decouple and simplify transitioning between http/https (eg in dev vs production), we use the dockerized [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) project. To further decouple that from the applications, it is run as a separate composition (see `proxy-separate-application` sub-directory) which should always be run, regardless of which constellation of services you want to deploy in your Data Warehouse.

Please visit each sub-directory to see further information.
