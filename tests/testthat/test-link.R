test_that("linkage works", {
  data_set_id <- "apc"

  # Get file paths
  # Use the dummy data from this package
  input_path <- extdata_path("data/apc/artificial_hes_apc_0102_truncated.parquet", mustWork = TRUE)
  patient_path <- extdata_path("patient_id_bridge.csv", mustWork = TRUE)
  # We'll append some fake data to this file, and use this as the input to the
  # data linkage function.
  # Create a temporary working directory for this test
  test_dir <- temp_dir()
  # Tidy up
  on.exit(unlink(test_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
  temp_input_path <- file.path(test_dir, "input.parquet")
  demographics_path <- file.path(test_dir, "demographics.parquet")
  # Generate a temporary output file
  output_path <- file.path(test_dir, "linked.parquet")

  # Count the number of rows in the input data set
  expected_apc_rows <- count_rows(input_path, read_func = 'read_parquet')

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
  generate_mock_demographics_data(path = demographics_path)

  # Run the data linkage workflow step
  expect_no_error(
    link(
      data_set_id = data_set_id,
      input_path = temp_input_path,
      output_path = output_path,
      patient_path = patient_path,
      demographics_path = demographics_path
    )
  )

  # TODO
  # Tests:
  # count rows
  actual_apc_rows <- count_rows(output_path, read_func = "read_parquet")
  expect_equal(actual_apc_rows, expected_apc_rows)
  # count columns
  # check unique identifier
})
