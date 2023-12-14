#!/bin/bash
set -e

# Download data
aws s3 sync s3://curedplus-raw.store.rcc.shef.ac.uk/NHSD-DATA/HES_OP/ ~/data/hes_op/raw/
cd ~/data/hes_op/raw/

# Unzip files
sh unzip.sh

# Import to DuckDB
duckdb -s ".read hes_op_import.sql"
