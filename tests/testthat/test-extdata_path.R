test_that("extdata_path works", {
  # This file must exist inside the inst/extdata directory.
  filename <- "README.md"
  expect_no_error(path <- extdata_path(filename))
  expect_equal(basename(path), filename)
})
