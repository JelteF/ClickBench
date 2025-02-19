#!/bin/bash

set -ex

CONNECTION=postgres://postgres:duckdb@localhost:5432/postgres
PSQL=psql

echo "Loading data"
(
    echo "\timing"
    cat create.sql
) | $PSQL $CONNECTION | grep 'Time'
