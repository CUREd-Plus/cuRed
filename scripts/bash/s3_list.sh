#!/bin/bash
set -e

# List files in a bucket
# https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html
uri="s3://curedplus-raw-binary.store.rcc.shef.ac.uk/"
profile="curedplus-raw-binary"

aws s3 ls --profile=$profile --human-readable --summarize --recursive $uri
