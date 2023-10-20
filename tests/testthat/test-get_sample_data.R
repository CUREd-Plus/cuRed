library(cli)

test_that("get_sample_data", {
  # Generate sample data from NHS Artificial data pilot
  # NHS Digital [Artificial data pilot
  # https://digital.nhs.uk/services/artificial-data
  data_urls <- c(
    "https://s3.eu-west-2.amazonaws.com/files.digital.nhs.uk/assets/Services/Artificial+data/Artificial+HES+final/artificial_hes_ae_202302_v1_sample.zip",
    "https://s3.eu-west-2.amazonaws.com/files.digital.nhs.uk/assets/Services/Artificial+data/Artificial+HES+final/artificial_hes_apc_202302_v1_sample.zip",
    "https://s3.eu-west-2.amazonaws.com/files.digital.nhs.uk/assets/Services/Artificial+data/Artificial+HES+final/artificial_hes_op_202302_v1_sample.zip"
  )
  number_of_rows <- 100

  tmpdir <- temp_dir()
  # Tidy up on failure
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  for (i in seq_len(length(data_urls))) {
    url <- data_urls[i]
    cli::cli_alert_info(url)
    # Ensure no errors occur
    expect_no_error(
      path <- get_sample_data(
        url = url,
        number_of_rows = number_of_rows,
        output_path = tempfile(fileext = ".csv", tmpdir = tmpdir)
      )
    )

    # Check the number of rows matches
    n_rows <- count_rows(path)
    expect_equal(n_rows, number_of_rows)

    # Append patient ID
    filename <- paste(basename(path), ".appended.csv")
    output_path <- file.path(dirname(path), filename)
    expect_no_error(
      appended_path <- append_mock_ids(
        input_path = path,
        output_path = output_path,
        format = "CSV"
      )
    )

    # Check row count
    n_rows <- count_rows(appended_path)
    expect_equal(n_rows, number_of_rows)
  }
})
