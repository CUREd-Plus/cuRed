#!/bin/bash
set -e

# Convert to Parquet, one file at a time
# Iterate over CSV files
for path in *.txt;
do
  date
  echo $path
  query_path=` mktemp --suffix=.sql`
  # Insert filename into template
  sed "s/{path}/$path/g" csv_to_parquet.sql > $query_path
  echo $query_path
  duckdb -c ".read $query_path"
done
