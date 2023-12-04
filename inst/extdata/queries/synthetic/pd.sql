-- Set the random seed to ensure reproducibility
SELECT setseed(0.0);
/*
Generate synthetic demographics data using DuckDB's range function
The number of rows generated is determined by the value of the variable 'n_rows'.
*/
COPY (
  SELECT
    uuid() AS study_id,
    'SG13' AS derived_postcode_dist,
    'F' AS gender,
    '1970-01' AS dob_year_month,
    NULL AS patient_care_extension,
    NULL AS death_notification_status,
    NULL AS derived_for_dodym,
    NULL AS derived_inf_dodym,
    NULL AS derived_rfr,
    NULL AS gp_pds_bus_eff_from,
    NULL AS nhais_pds_bus_eff_from,
    NULL AS rfr_pds_bus_eff_from
    
  -- For more information on the range function, see:
  -- https://duckdb.org/docs/sql/functions/nested.html
  FROM range({n_rows})
)
-- Write the generated data to the specified output path
TO '{output_path}';
