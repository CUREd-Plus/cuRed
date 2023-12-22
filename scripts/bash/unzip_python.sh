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

python3.11 -c 'import zlib; print("zlib", zlib.ZLIB_VERSION)'
python3.11 -c 'import zipfile; print("ZIP_DEFLATED", zipfile.ZIP_DEFLATED)'

# Iterate over zip files
for path in $source_dir/*.zip;
do
  ls -lh $path
  # Verify ZIP file
  python3.11 -m zipfile --test $path
  # Show file contents
  python3.11 -m zipfile --list $path
  # Decompress in the background
  # https://docs.python.org/3/library/zipfile.html#command-line-interface
  python3.11 -m zipfile --decompress --time -e $path $target_dir &
done
