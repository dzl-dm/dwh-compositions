#!/bin/bash
## Loads the sql with concept meta data for querying
## Relies on the sql files being presented to the container (usually via a mount)

docker exec -it i2b2.database su - postgres sh -c 'cd /tmp/new-sql/; find . -type f -iname "*.sql" -exec psql -d i2b2 -f {} \;'
