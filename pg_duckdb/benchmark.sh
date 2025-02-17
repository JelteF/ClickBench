#!/bin/bash

set -ex

#sudo apt-get update
#sudo apt-get install -y docker.io
#sudo apt-get install -y postgresql-client

seq 0 99 | xargs -P100 -I{} bash -c 'wget --no-verbose --continue https://datasets.clickhouse.com/hits_compatible/athena_partitioned/hits_{}.parquet'
sudo docker run -d --name pgduck -p 5432:5432 -e POSTGRES_PASSWORD=duckdb -v .:/tmp/ pgduckdb/pgduckdb:17-v0.3.1

sleep 5
psql postgres://postgres:duckdb@localhost:5432/postgres -f create.sql
./run.sh 2>&1 | tee log.txt

sudo docker exec -it pgduck du -bcs /var/lib/postgresql/data /tmp/hits_{0..99}.parquet

cat log.txt | grep -oP 'Time: \d+\.\d+ ms' | sed -r -e 's/Time: ([0-9]+\.[0-9]+) ms/\1/' |
    awk '{ if (i % 3 == 0) { printf "[" }; printf $1 / 1000; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }'
