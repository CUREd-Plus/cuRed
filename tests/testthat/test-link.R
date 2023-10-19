test_that("linkage works", {
  # Get file paths
  # Use the dummy data from this package
  input_path <- extdata_path("data/apc/artificial_hes_apc_0102_truncated.parquet", mustWork = TRUE)
  patient_path <- extdata_path("patient_id_bridge.csv", mustWork = TRUE)
  # We'll append some fake data to this file, and use this as the input to the
  # data linkage function.
  # Create a temporary working directory for this test
  test_dir <- temp_dir()
  dir.create(test_dir, recursive = TRUE)
  temp_input_path <- tempfile(fileext = ".parquet", tmpdir = test_dir)
  demographics_path <- tempfile(fileext = ".parquet", tmpdir = test_dir)
  output_path <- tempfile(fileext = ".parquet", tmpdir = test_dir)
  

  # Append fake patient ID to the HES synthetic data
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

  # Run the data linkage workflow step
  expect_no_error(
    link(
      input_path = temp_input_path,
      output_path = output_path,
      patient_path = patient_path,
      demographics_path = demographics_path
    )
  )

  # TODO
  # Tests:
  # count rows
  # count columns
  # check unique identifier

  # Tidy up
  on.exit(unlink(test_dir, recursive = TRUE, force = TRUE))
})
