-- https://duckdb.org/docs/data/parquet/overview.html
COPY (
  SELECT
     apc.epikey
    ,patient.yas_id
    ,patient.token_person_id
    ,patient.cured_id
    ,demographics.*
  FROM read_parquet('{input_path}') AS apc
  LEFT JOIN read_csv_auto('{patient_path}', header=true, all_varchar=true) AS patient
    ON apc.token_person_id = patient.token_person_id
  LEFT JOIN read_parquet('{demographics_path}') AS demographics
    ON apc.study_id = demographics.study_id
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
