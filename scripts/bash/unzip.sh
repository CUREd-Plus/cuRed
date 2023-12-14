#!/bin/bash
set -e

# This script will unzip zip files while
# saving space (deleting the files as we go)

# If you have plenty of disk space then don't
# use this script, just run unzip "*.zip"

# Iterate over zip files
for path in *.zip;
do
  echo $path
  # Decompress
  unzip $path
  # Delete zip archive
  rm -v $path
done
