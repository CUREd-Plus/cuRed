library(logger)

test_that("csv_to_binary", {
  # Automatic test for the csv_to_binary() function

  # Create a temporary working directory
  tmpdir <- temp_dir()
  # Tidy up (delete files) on exit or failure
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  # Append dummy patient IDs to the artificial APC data
  input_path = file.path(extdata_path(""), "data/apc/*.csv")
  output_path = file.path(tmpdir, "artificial_hes_apc_appended.csv")
  query <- stringr::str_glue("SELECT setseed(0.0); COPY (
  SELECT
     uuid() AS token_person_id
    ,uuid() AS study_id
    ,artificial_apc.*
  FROM read_csv_auto('{input_path}') AS artificial_apc
)
TO '{output_path}'
WITH (FORMAT 'CSV', HEADER);
")
  run_query(query)
  logger::log_info("Wrote '{output_path}'")

  # Run the function on test data
  expect_no_error(
    output_paths <- csv_to_binary(
      input_dir = tmpdir,
      output_dir = tmpdir,
      data_set_id = "apc"
    )
  )

  # Check the output files
  for (i in seq_len(length(output_paths))) {
    output_path <- output_paths[i]
    # Ensure the file is valid Parquet format
    expect_no_error(
      read_parquet(output_path)
    )
    expect_no_error(
      parquet_metadata(output_path)
    )
  }
})
