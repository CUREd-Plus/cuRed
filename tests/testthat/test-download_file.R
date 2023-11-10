test_that("download_file", {

  # This should be a permanent URL that won't change
  url <- "https://www.w3.org/Provider/Style/URI"

  destfile <- tempfile()
  on.exit(unlink(destfile, force = TRUE), add = TRUE, after = FALSE)

  # Download the file
  expect_no_error(
    download_file(url, destfile = destfile)
  )

  # Check file size
  expect_equal(file.info(destfile)$size, expected = 18910)
})
