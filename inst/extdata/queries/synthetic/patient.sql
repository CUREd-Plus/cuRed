-- Set the random seed to ensure reproducibility
SELECT setseed(0.0);
/*
Generate synthetic patient identifiers.
*/
COPY (
  SELECT
    -- Random ~6-digit integer
     CAST(RANDOM() * 1e6 AS INTEGER) AS study_id
    -- Random uppercase alphanumeric string
    ,LEFT(REPLACE(UPPER(UUID()), '-', ''), 15) AS pseudo_person_id
    
  -- For more information on the range function, see:
  -- https://duckdb.org/docs/sql/functions/nested.html
  FROM range({n_rows})
)
-- Write the generated data to the specified output path
TO '{output_path}';
