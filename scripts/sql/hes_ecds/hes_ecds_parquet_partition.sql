/*
DuckDB Hive partitioning
https://duckdb.org/docs/data/partitioning/hive_partitioning.html

Create a partitioned data set
https://duckdb.org/docs/data/partitioning/partitioned_writes
*/

-- All queries performed will be profiled, with output in json format.
-- By default the result is still printed to stdout.
PRAGMA enable_profiling = 'json';
-- Instead of writing to stdout, write the profiling output to a specific file on disk.
-- This has no effect for `EXPLAIN ANALYZE` queries, which will *always* be
-- returned as query results.
PRAGMA profile_output='/mnt/sdd/hes_op/profile.json';

-- Assume we've already imported the data into a table
COPY hes_ecds
TO 'hes_ecds_parquet' (
  FORMAT PARQUET,
  PARTITION_BY(appointment_year, appointment_month),
  OVERWRITE_OR_IGNORE
);
