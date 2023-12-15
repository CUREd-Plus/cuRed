/*
Create a partitioned data set
https://duckdb.org/docs/data/partitioning/partitioned_writes
*/
COPY hes_ecds
TO 'hes_ecds_parquet' (
  FORMAT PARQUET,
  PARTITION_BY(arrival_year, arrival_month_of_year),
  OVERWRITE_OR_IGNORE
);
