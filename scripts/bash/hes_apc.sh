#!/bin/bash
set -e

data_set_id=hes_apc
raw_dir=~/data/hes_apc/raw/

# Download data
time aws s3 sync s3://curedplus-raw.store.rcc.shef.ac.uk/NHSD-DATA/HES_APC/ $raw_dir
cd $raw_dir

# Unzip files
time unzip "*.zip" -d /mnt/sdd/hes_op/raw/
time rm *.zip

# Convert to Parquet, one file at a time
# Iterate over CSV files
for path in *.txt;
do
  date
  echo $path
  query_path=` mktemp --suffix=.sql`
  # Insert filename into template
  sed "s/{path}/$path/g" hes_apc_csv_to_parquet.sql > $query_path
  echo $query_path
  time duckdb -c ".read $query_path"
  mv profiling.json "profiling_`date`.json"
done
