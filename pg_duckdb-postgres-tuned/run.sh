#!/bin/bash

TRIES=3
CONNECTION=postgres://postgres:duckdb@localhost:5432/postgres

cat queries.sql | while read -r query; do
    echo "$query"
    (
        echo 'set duckdb.force_execution = true;'
        echo '\timing'
        yes "$query" | head -n $TRIES
    ) | psql -X -t $CONNECTION | grep 'Time'
done
