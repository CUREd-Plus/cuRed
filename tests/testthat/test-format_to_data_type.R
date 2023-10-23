test_that("Convert TOS Format to integer SQL data type", {
  format_str <- "Number"
  data_type <- format_to_data_type(format_str)
  testthat::expect_match(data_type, ".*INT.*")
  testthat::expect_equal(data_type, "UBIGINT")
})

test_that("Convert TOS Format to string SQL data type", {
  format_str <- "String(4)"
  data_type <- format_to_data_type(format_str)
  testthat::expect_match(data_type, "VARCHAR*")
  # TODO testthat::expect_equal(data_type, "VARCHAR(4)")
})

test_that("Convert TOS Format to date SQL data type", {
  format_str <- "Date(YYYY-MM-DD)"
  data_type <- format_to_data_type(format_str)
  testthat::expect_equal(data_type, "DATE")
})

test_that("Convert TOS Format to time SQL data type", {
  format_str <- "Time(HH24:MI:ss)"
  data_type <- format_to_data_type(format_str)
  testthat::expect_equal(data_type, "TIME")
})
