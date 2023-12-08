/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

-- Get the first 10 rows
SELECT LIMIT 10
  *
FROM read_csv('*.txt', , delim = '|', all_varchar=true)
