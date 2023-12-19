/*
Create a partitioned data set
https://duckdb.org/docs/data/partitioning/partitioned_writes
*/
COPY hes_ae
TO 'hes_ae_parquet' (
  FORMAT PARQUET,
  PARTITION_BY(arrival_year, arrival_month),
  OVERWRITE_OR_IGNORE
);
