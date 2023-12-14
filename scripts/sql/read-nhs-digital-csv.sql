/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
  COUNT(*)
FROM read_csv('*.txt', , delim = '|', all_varchar=true)
