-- https://duckdb.org/docs/data/parquet/overview.html
COPY (
  SELECT
     apc.*
    ,patient.yas_id
    ,patient.token_person_id
    ,patient.cured_id
    ,deaths.*
    ,demographics.*
  FROM read_parquet('{input_path}') AS apc
  -- LEFT JOIN read_parquet('{patient_path}') AS patient
  LEFT JOIN read_csv_auto('{patient_path}', header=true, all_varchar=true) AS patient
	  ON apc.token_person_id = patient.token_person_id
  LEFT JOIN read_csv_auto('{deaths_path}', header=true, all_varchar=true) AS deaths
	  ON apc.token_person_id = deaths.token_person_id
  LEFT JOIN read_csv_auto('{demographics_path}', header=true, all_varchar=true) AS demographics
	  ON apc.token_person_id = demographics.token_person_id
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
