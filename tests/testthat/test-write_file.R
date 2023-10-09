library(stringr)

test_that("write_file works", {
  data <- "Hello, world!"
  file_path <- tempfile(fileext = ".txt")

  write_file(file_path = file_path, data = data)

  # Check file exists
  expect_true(file.exists(file_path))

  # Check file contents are correct
  test_data <- stringr::str_trim(readChar(file_path, nchars = file.info(file_path)$size))
  expect_equal(test_data, data)

  file.remove(file_path)
})
