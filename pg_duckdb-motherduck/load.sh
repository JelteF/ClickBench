#!/bin/bash

set -e

CONNECTION=postgres://postgres:duckdb@localhost:5432/postgres

DATABASE='ddb$pgclick'
PARQUET_FILE='https://datasets.clickhouse.com/hits_compatible/hits.parquet'

echo "Loading data"
(
    cat create.sql | sed -e "s=REPLACE_SCHEMA=$DATABASE=g" -e "s=REPLACE_PARQUET_FILE=$PARQUET_FILE=g"
) | psql --no-psqlrc --tuples-only $CONNECTION
