#!/bin/bash

# Install

curl https://clickhouse.com/ | sh

# Configure

> clickhouse-local.yaml echo "
filesystem_caches:
    cache:
        path: '/dev/shm/clickhouse/'
        max_size: '16G'
"

# Run the queries

./run.sh

echo "Load time: 0"
echo "Data size: 14737666736"
