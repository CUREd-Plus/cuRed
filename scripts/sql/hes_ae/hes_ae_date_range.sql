/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
   COUNT(*) AS row_count
  ,MIN(ARRIVALDATE) AS MIN_ARRIVALDATE
  ,MAX(ARRIVALDATE) AS MIN_ARRIVALDATE
FROM hes_ae;
