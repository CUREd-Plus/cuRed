/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
   COUNT(*) AS row_count
  ,MIN(ARRIVALDATE) AS MIN_ARRIVALDATE
  ,MAX(ARRIVALDATE) AS MIN_ARRIVALDATE
  ,MIN(SUSLDDATE) AS MIN_SUSLDDATE
  ,MAX(SUSLDDATE) AS MIN_SUSLDDATE

FROM read_csv_auto('*.txt', delim = '|', all_varchar=true)
