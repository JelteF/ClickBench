#!/usr/bin/env python3

from pysail.spark import SparkConnectServer
from pyspark.sql import SparkSession
import pyspark.sql.functions as F

import timeit
import psutil
import sys
import re

query = sys.stdin.read()
# Replace \1 to $1 because spark recognizes only this pattern style (in query 28)
query = re.sub(r"""(REGEXP_REPLACE\(.*?,\s*('[^']*')\s*,\s*)('1')""", r"\1'$1'", query)
print(query)

import os
os.environ["SAIL_PARQUET__BINARY_AS_STRING"] = "true"
os.environ["SAIL_PARQUET__PUSHDOWN_FILTERS"] = "true"
os.environ["SAIL_PARQUET__REORDER_FILTERS"] = "true"
os.environ["SAIL_RUNTIME__ENABLE_SECONDARY"] = "true"
os.environ["SAIL_PARQUET__ALLOW_SINGLE_FILE_PARALLELISM"] = "true"

server = SparkConnectServer()
server.start()
_, port = server.listening_address

spark = SparkSession.builder.remote(f"sc://localhost:{port}").getOrCreate()

df = spark.read.parquet("hits.parquet")
# Do casting before creating the view so no need to change to unreadable integer dates in SQL
df = df.withColumn("EventTime", F.timestamp_seconds("EventTime"))
df = df.withColumn("EventDate", F.date_add(F.lit("1970-01-01"), F.col("EventDate")))
df.createOrReplaceTempView("hits")

for try_num in range(3):
    try:
        start = timeit.default_timer()
        result = spark.sql(query)
        res = result.toPandas()
        if try_num == 0:
            print(res)
        end = timeit.default_timer()
        print("Time: ", round(end - start, 3))
    except Exception as e:
        print(e);
        print("Failure!")
