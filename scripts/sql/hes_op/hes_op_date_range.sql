/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
   COUNT(*) AS row_count
  ,MIN(NULLIF(apptdate, '1900-01-01')) AS min_apptdate
  ,MAX(NULLIF(apptdate, '1900-01-01')) AS max_apptdate
  ,MIN(NULLIF(dnadate, '1900-01-01')) AS min_dnadate
  ,MAX(NULLIF(dnadate, '1900-01-01')) AS max_dnadate
  ,MIN(NULLIF(reqdate, '1900-01-01')) AS min_reqdate
  ,MAX(NULLIF(reqdate, '1900-01-01')) AS max_reqdate
FROM hes_ae;
