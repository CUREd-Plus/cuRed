-- https://duckdb.org/docs/data/parquet/overview.html
COPY (
  SELECT
     apc.epikey
    ,patient.yas_id
    ,patient.token_person_id
    ,patient.cured_id
  FROM read_parquet('{input_path}') AS apc
  LEFT JOIN read_parquet('{patient_path}') AS patient
    ON apc.token_person_id = patient.token_person_id
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
