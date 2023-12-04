test_that("linkage works", {
  data_set_id <- "apc"

  # Get file paths
  # Use the dummy data from this package
  raw_data_path <- extdata_path("data/apc/artificial_hes_apc_0102_truncated.parquet", mustWork = TRUE)
  patient_path <- extdata_path("patient_id_bridge.csv", mustWork = TRUE)
  # We'll append some fake data to this file, and use this as the input to the
  # data linkage function.

  # Create a temporary working directory for this test
  test_dir <- temp_dir()
  # Tidy up (delete temporary files) on failure or exit
  #on.exit(unlink(test_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  # Count the number of rows in the input data set
  apc_rows <- count_rows(raw_data_path, read_func = 'read_parquet')

  # Generate dummy data
  # Append fake patient ID to the HES synthetic data
  # We'll append some fake data to this file, and use this as the input to the data linkage code.
  input_path <- file.path(test_dir, "artificial_hes_apc_0102_truncated_appended.parquet")
  run_query(stringr::str_glue("SELECT setseed(0.0);
COPY (
  SELECT
     uuid() AS token_person_id
    ,uuid() AS study_id
    ,apc.*
  FROM read_parquet('{raw_data_path}') AS apc
)
TO '{input_path}' WITH (FORMAT 'PARQUET');
"))
  cli::cli_inform("Wrote '{input_path}'")

  # Generate mock patient demographics data
  demographics_path <- file.path(test_dir, "demographics.parquet")
  generate_demographics(demographics_path)

  # Run the data linkage workflow step
  output_path <- file.path(test_dir, "linked.parquet")
  expect_no_error(
    link(
      data_set_id = data_set_id,
      input_path = input_path,
      output_path = output_path,
      patient_path = patient_path,
      demographics_path = demographics_path,
      patient_key = "token_person_id"
    )
  )

  # TODO
  # Tests:
  # count rows
  expect_equal(apc_rows, count_rows(output_path, read_func = "read_parquet"))
  # count columns
  # check unique identifier
})
