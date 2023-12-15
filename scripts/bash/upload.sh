#!/bin/bash
set -e

# Upload to object storage
# aws s3 sync https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html
dest="s3://curedplus-raw-binary.store.rcc.shef.ac.uk/hes_apc/"
profile="curedplus-raw-binary-write"
aws s3 sync --profile=$profile --include="*.parquet" . $dest
