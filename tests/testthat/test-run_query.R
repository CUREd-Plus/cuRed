test_that("DuckDB works", {
  
  query <- "SELECT get_current_timestamp();"
  
  affected_rows_count <- run_query(query = query)
  
  testthat::expect_type(affected_rows_count, "integer")
  testthat::expect_equal(affected_rows_count, 0)
})
