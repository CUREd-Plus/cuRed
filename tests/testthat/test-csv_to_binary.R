library(cli)

test_that("csv_to_binary", {
  # Automatic test for the csv_to_binary() function

  # Create a temporary working directory
  tmpdir <- temp_dir()
  # Tidy up (delete files) on exit or failure
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  # Append mock patient ID bridge
  append_mock_ids(
    input_path = file.path(extdata_path(""), "/data/apc/*.csv"),
    output_path = file.path(tmpdir, "apc_appended.csv")
  )

  # Get TOS
  url <- "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"
  tos_path <- file.path(tmpdir, basename(url))
  download_file(url, destfile = tos_path)

  # Get metadata from the TOS
  metadata <- parse_tos(tos_path, sheet = "HES APC TOS")

  # Create a binary file at this location
  output_path <- file.path(tmpdir, "output.parquet")

  # Run the function on test data
  expect_no_error(
    csv_to_binary(
      input_dir = tmpdir,
      output_path = output_path,
      metadata = metadata,
      data_set_id = "apc"
    )
  )

  # Check the output file
  expect_no_error(
    read_parquet(output_path)
  )
  expect_no_error(
    parquet_metadata(output_path)
  )
})
