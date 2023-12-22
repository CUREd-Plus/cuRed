#!/bin/bash
set -e

# This script will unzip zip files
# Usage:
# sh unzip.sh ~/input_dir/ ~/output_dir/

# Default: current directory
source_dir="${1:=.}"
target_dir="${2:=.}"

# Create destination folder
mkdir -vp $target_dir

# Iterate over zip files
for path in $source_dir/*.zip;
do
  echo $path
  # Decompress in the background
  # https://docs.python.org/3/library/zipfile.html#command-line-interface
  python3 -m zipfile --decompress --time -e $path $target_dir &
done
