test_that("get_sample_data", {
  data_urls <- c(
    "https://s3.eu-west-2.amazonaws.com/files.digital.nhs.uk/assets/Services/Artificial+data/Artificial+HES+final/artificial_hes_ae_202302_v1_sample.zip",
    "https://s3.eu-west-2.amazonaws.com/files.digital.nhs.uk/assets/Services/Artificial+data/Artificial+HES+final/artificial_hes_apc_202302_v1_sample.zip",
    "https://s3.eu-west-2.amazonaws.com/files.digital.nhs.uk/assets/Services/Artificial+data/Artificial+HES+final/artificial_hes_op_202302_v1_sample.zip"
  )
  number_of_rows <- 100

  # Ensure no errors occur
  expect_no_error(
    paths <- get_sample_data(
      data_urls = data_urls,
      number_of_rows = number_of_rows
    )
  )

  # Check the number of rows matches
  for (path in paths) {
    n_rows <- count_rows(path, read_func="read_csv")
    expect_equal(nrows, number_of_rows)
  }
})
