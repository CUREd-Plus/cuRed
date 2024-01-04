#!/bin/bash
set -e

# Usage:
# sh unzip.sh ~/data/path

# This script will unzip zip files while
# Destination folder. Default: current directory
target_dir="${1:=.}"

# Create destination folder
mkdir -vp $target_dir

# Iterate over zip files
for path in *.zip;
do
  # Decompress in the background
  7zz e "$path" -o"$target_dir" -y &
done
