test_that("historic_address", {
  # Create temporary working directory
  working_dir <- temp_dir()
  on.exit(unlink(working_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  # Load test data set
  raw_input_path <- extdata_path("data/apc/artificial_hes_apc_0102_truncated.parquet", mustWork = TRUE)
  raw_input_rows <- count_rows(input_path, read_func = "read_parquet")
  
  # Append mock patient ID fields
  input_path <- file.path(working_dir, "apc_with_mock_patient_ids.parquet")
  query <- stringr::str_glue("SELECT setseed(0.0);
COPY (
  SELECT
    -- Replicate input data
     input_data.*
      -- Generate mock patient identifiers
    ,uuid() AS token_person_id
    ,uuid() AS yas_id
    ,uuid() AS cured_id
    ,uuid() AS study_id
  FROM read_parquet('{raw_input_path}') AS input_data
)
TO '{input_path}'")
  run_query(query)
  
  # Get mock historic address data
  address_path <- generate_synthetic_data(
    query_template_path = extdata_path("queries/synthetic/historic_addresses.sql", mustWork = TRUE),
    output_path = file.path(working_dir, "historic_addresses.parquet")
  )
  
  output_path <- file.path(working_dir, "output.parquet")
  
  # Run address merge
  expect_no_error(
    historic_address(
      input_path = input_path,
      address_path = address_path,
      output_path = output_path,
      date_column = "admidate"
    )
  )
  
  # Check data integrity
  # Ensure the number of records hasn't changed
  expect_equal(count_rows(output_path, read_func = "read_parquet"), input_rows)
})
