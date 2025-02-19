#!/bin/bash

set -ex

# Setup on Ubuntu (your package manager may vary):
# sudo snap install docker
# sudo apt install postgresql-client

# Create a persistent data directory that can be used across container restarts
mkdir -p pgdata
chmod 777 pgdata

wget --no-verbose --continue 'https://datasets.clickhouse.com/hits_compatible/hits.tsv.gz'
gzip -d hits.tsv.gz

sudo docker run -d --name pgduck -p 5432:5432 -e POSTGRES_PASSWORD=duckdb -e PGDATA=/pgdata/data -v ./pgdata:/pgdata -v ./hits.parquet:/tmp/hits.parquet pgduckdb/pgduckdb:17-v0.3.1 -c duckdb.max_memory=10GB -c shared_buffers=8GB -c max_parallel_workers=16 -c max_parallel_workers_per_gather=8 -c max_wal_size=32GB

# Give postgres time to start running
sleep 5

export PGPASSWORD=duckdb
export PGUSER=postgres

psql <create.sql
time split hits.tsv --verbose -n r/$(($(nproc) / 2)) --filter='psql -t -c "\\copy hits FROM STDIN"'

psql -t -c 'CREATE EXTENSION pg_trgm;'
time psql -t <index.sql

time psql -t -c 'VACUUM ANALYZE hits'

./run.sh 2>&1 | tee log.txt

du -bcs pgdata

cat log.txt | grep -oP 'Time: \d+\.\d+ ms' | sed -r -e 's/Time: ([0-9]+\.[0-9]+) ms/\1/' |
    awk '{ if (i % 3 == 0) { printf "[" }; printf $1 / 1000; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }'
