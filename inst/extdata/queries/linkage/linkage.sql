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
    ,demographics.patient_care_extension
    ,demographics.death_notification_status
    ,demographics.derived_for_dodym
    ,demographics.derived_inf_dodym
    ,demographics.derived_rfr
    ,demographics.gp_pds_bus_eff_from
    ,demographics.nhais_pds_bus_eff_from
    ,demographics.rfr_pds_bus_eff_from

  FROM read_parquet('{input_path}') AS {data_set_id}
  -- Merge with patient ID bridge
  LEFT JOIN read_csv_auto('{patient_path}', header=true, all_varchar=true) AS patient
    ON {data_set_id}.{patient_key} = patient.{patient_key}
  -- Merge with patient demographics
  LEFT JOIN read_parquet('{demographics_path}') AS demographics
    ON {data_set_id}.study_id = demographics.study_id
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
