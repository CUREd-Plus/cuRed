#!/bin/bash
set -e

for path in *.zip;
do
  echo $path
  unzip $path
  rm -v $path
done
