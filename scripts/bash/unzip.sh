#!/bin/bash
set -e

# This script will unzip zip files while
# saving space (deleting the files as we go)

# If you have plenty of disk space then don't
# use this script, just run unzip "*.zip"

target_dir=.
mkdir -p $target_dir

# Iterate over zip files
for path in *.zip;
do
  echo $path
  # Decompress and unzip in the background
  unzip $path -d $target_dir && rm -v $path &
done
