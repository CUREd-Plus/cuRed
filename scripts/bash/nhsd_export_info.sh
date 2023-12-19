# Concatenate the export info files
head -q -n 1 *.csv | head -n 1 && tail -n 1 -q *.csv
