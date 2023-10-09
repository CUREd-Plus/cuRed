-- Convert CSV files to Apache Parquet format
-- DuckDB COPY statement documentation
-- https://duckdb.org/docs/sql/statements/copy
COPY (
  SELECT *
  -- Define data types
  -- DuckDB documentation for CSV loading
  -- https://duckdb.org/docs/data/csv/overview.html
  FROM read_csv('{input_glob}',
	header=TRUE,
	filename=TRUE,
	-- Columns must be ordered
	columns={data_types_struct}
  )
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
