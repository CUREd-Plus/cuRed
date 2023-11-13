/*
This is a generic data linkage query that should work
for most data sets.

This query will append extra fields to the input data set.

The output will be saved to a Parquet file.

Reading Parquet files using DuckDB:
https://duckdb.org/docs/data/parquet/overview.html
*/
COPY (
  SELECT
     {fields_sql}
	-- Patient ID bridge
    ,patient.yas_id
    ,patient.token_person_id
    ,patient.cured_id
	-- Demographics
    ,demographics.derived_postcode_dist
	,demographics.gender
	,demographics.dob_year_month
  FROM read_parquet('{input_path}') AS data_set
  LEFT JOIN read_csv_auto('{patient_path}', header=true, all_varchar=true) AS patient
    ON data_set.token_person_id = patient.token_person_id
  LEFT JOIN read_parquet('{demographics_path}') AS demographics
    ON data_set.study_id = demographics.study_id
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
