#!/bin/bash
set -e

data_set_id=hes_ae
raw_dir=~/data/hes_ae/raw/

# Download data
time aws s3 sync s3://curedplus-raw.store.rcc.shef.ac.uk/NHSD-DATA/HES_AE/ $raw_dir
cd $raw_dir

# Unzip files
time unzip "*.zip" -d /mnt/sdd/hes_op/raw/
time rm *.zip

time duckdb -c ".read hes_ae_csv_to_parquet.sql"
mv profiling.json "profiling_`date`.json"

# Upload to object storage
time aws s3 sync --profile=bin-rw ~/data/hes_ae/raw/hes_ae_parquet/ s3://curedplus-raw-binary.store.rcc.shef.ac.uk/hes_ae/
