test_that("extdata_path", {
  # This file must exist inside the inst/extdata directory.
  filename <- "README.md"
  expect_no_error(path <- extdata_path(filename))
  expect_equal(basename(path), filename)
})

test_that("extdata_path empty string", {
  # This file must exist inside the inst/extdata directory.
  filename <- ""
  expect_no_error(path <- extdata_path(filename))
  expect_equal(basename(path), "extdata")
})
