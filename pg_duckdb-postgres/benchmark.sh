#!/bin/bash

set -ex

# Setup on Ubuntu (your package manager may vary):
# sudo snap install docker
# sudo apt install postgresql-client

# Create a persistent data directory that can be used across container restarts
mkdir -p pgdata
chmod 777 pgdata

wget --no-verbose --continue https://datasets.clickhouse.com/hits_compatible/athena/hits.parquet

sudo docker run -d --name pgduck -p 5432:5432 -e POSTGRES_PASSWORD=duckdb -e PGDATA=/pgdata/data -v ./pgdata:/pgdata -v ./hits.parquet:/tmp/hits.parquet pgduckdb/pgduckdb:17-v0.3.1 -c duckdb.max_memory=10GB

# Give postgres time to start running
sleep 5

./load.sh 2>&1 | tee load_log.txt

./run.sh 2>&1 | tee log.txt

# Go to https://app.motherduck.com and execute:
# `SELECT database_size FROM pragma_database_size() WHERE database_name = 'pgclick'`
# 25 GB

cat log.txt | grep -oP 'Time: \d+\.\d+ ms' | sed -r -e 's/Time: ([0-9]+\.[0-9]+) ms/\1/' |
    awk '{ if (i % 3 == 0) { printf "[" }; printf $1 / 1000; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }'
