test_that("csv_to_binary", {
  # Create a temporary working directory
  tmpdir <- temp_dir()
  # Tidy up (delete files) on exit or failure
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  input_dir <- extdata_path("data/apc/raw")

  # Run the function on test data
  expect_no_error(
    output_paths <- csv_to_binary(
      input_dir = input_dir,
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
