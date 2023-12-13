/*
Read data from partitioned Parquet data set.

See: Hive partitioning
https://duckdb.org/docs/data/partitioning/hive_partitioning.html
*/
SELECT COUNT(*)
FROM read_parquet('hes_ae_parquet/**/*.parquet', hive_partitioning = true);
