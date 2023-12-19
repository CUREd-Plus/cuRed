/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
   MIN(apptdate) AS min_apptdate
  ,MAX(apptdate) AS max_apptdate
FROM hes_op;
