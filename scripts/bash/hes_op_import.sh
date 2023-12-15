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
duckdb hes_op.duckdb -c ".read ../sql/hes_op/hes_op_import.sql"

# Check row count
duckdb hes_op.duckdb -readonly -csv -c "SELECT filename, COUNT(*) AS row_count FROM hes_op GROUP BY 1, ORDER BY 1 ASC;" > hes_op_filename_row_count.csv

# Check columns
duckdb hes_op.duckdb -readonly -csv -c "DESCRIBE TABLE hes_op;" > describe_table_hes_op.csv

# Check date range
duckdb hes_op.duckdb -readonly -c ".read ../sql/hes_op/hes_op_date_range.sql"

# Convert to Parquet format (partitioned)
duckdb hes_op.duckdb -readonly -stats -c ".read ../sql/hes_op_parquet_partition.sql"
