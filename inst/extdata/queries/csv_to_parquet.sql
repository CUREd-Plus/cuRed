-- Convert from CSV to Parquet
-- https://duckdb.org/docs/data/csv/overview.html
COPY (
  SELECT *
  -- Assume all columns are strings because the "auto" detection is inconsistent
  FROM read_csv_auto('{input_path}', header=true, all_varchar=true)
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
