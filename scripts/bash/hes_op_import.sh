#!/bin/bash
set -e

# Download data
aws s3 sync s3://curedplus-raw.store.rcc.shef.ac.uk/NHSD-DATA/HES_OP/ ~/data/hes_op/raw/
cd ~/data/hes_op/raw/

# Unzip files
unzip "*.zip" -d /mnt/sdd/hes_op/raw/
rm *.zip

# Check row count (checksum)
wc -l "/mnt/sdd/hes_op/raw/FILE*.txt" > hes_op_row_count.txt

# Import to DuckDB
duckdb hes_op.duckdb -s ".read ../sql/hes_op/hes_op_import.sql"

# Check columns

# Check date range
