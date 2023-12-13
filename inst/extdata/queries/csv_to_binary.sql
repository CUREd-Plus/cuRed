/*
Convert CSV files to Apache Parquet format.
*/

-- Set working location
SET temp_directory = '{temp_directory}';

-- DuckDB COPY statement documentation
-- https://duckdb.org/docs/sql/statements/copy
COPY (
  -- Parse CSV files
  -- DuckDB documentation for CSV loading
  -- https://duckdb.org/docs/data/csv/overview.html
  SELECT *
  FROM read_csv('{input_glob}',
	header={header},
	filename=TRUE,
	delim='{delim}',
	-- Define data types. (Columns must be ordered.)
	columns={data_types_struct}
  )
)
-- Write output binary data files
TO '{output_path}';
