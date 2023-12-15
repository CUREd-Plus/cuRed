/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
   COUNT(*) AS row_count
  ,MIN(NULLIF(ARRIVALDATE, '1900-01-01')) AS MIN_ARRIVALDATE
  ,MAX(NULLIF(ARRIVALDATE, '1900-01-01')) AS MAX_ARRIVALDATE
FROM hes_ae;
