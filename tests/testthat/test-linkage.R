test_that("linkage works", {
  # Get file paths
  input_path <- extdata_path("artificial_hes_apc_0102.parquet")
  # Generate a temporary output file
  output_path <- tempfile(fileext = ".parquet")
  patient_path <- extdata_path("patient_id_bridge.csv")

  # Count the number of rows in the input data set
  apc_rows <- count_rows(input_path)

  # Generate dummy data
  # Append fake patient ID to the HES synthetic data
  # We'll append some fake data to this file,
  # and use this as the input to the data linkage code.
  temp_input_path <- tempfile(fileext = ".parquet")
  run_query(stringr::str_glue("
COPY (
  SELECT
    -- Generate mock patient identifiers
    uuid() AS token_person_id,
    uuid() AS yas_id,
    uuid() AS cured_id,
    uuid() AS study_id,
    apc.*
  FROM read_parquet('{input_path}') AS apc
)
TO '{temp_input_path}'
WITH (FORMAT 'PARQUET');
"))

  # Generate mock patient demographics data
  demographics_path <- tempfile(fileext = ".parquet")
  run_query(stringr::str_glue("
COPY (
  SELECT
    uuid() AS study_id,
    'SG13' AS derived_postcode_dist,
    'F' AS gender,
    '1970-01' AS dob_year_month
  -- https://duckdb.org/docs/sql/functions/nested.html
  FROM generate_series(1, 10)
)
TO '{demographics_path}'
WITH (FORMAT 'PARQUET');
"))

  # Generate mock death data
  deaths_path <- tempfile(fileext = ".parquet")
  run_query(stringr::str_glue("
COPY (
  SELECT
    uuid() AS token_person_id,
    uuid() AS study_id,
    CAST('2010-01-01' AS DATE) AS reg_date_of_death,
    70 AS dec_agec,
    '?' AS dec_marital_status,
    '?' AS dec_occ_type,
    '?' AS pod_code,
    '?' AS reg_date
  FROM generate_series(1, 10)
)
TO '{deaths_path}'
WITH (FORMAT 'PARQUET');
"))

  # Run the data linkage workflow step
  expect_no_error(
    link(
      input_path = temp_input_path,
      output_path = output_path,
      patient_path = patient_path,
      demographics_path = demographics_path,
      deaths_path = deaths_path
    )
  )

  # TODO
  # Tests:
  # count rows
  expect_equal(apc_rows, count_rows(output_path))
  # count columns
  # check unique identifier

  # Tidy up
  file.remove(demographics_path)
  file.remove(deaths_path)
  file.remove(output_path)
})
