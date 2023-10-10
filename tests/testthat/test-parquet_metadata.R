library(stringr)

test_that("parquet_metadata works", {
  # Generate dummy data
  path <- tempfile(fileext = ".parquet")
  query <- stringr::str_glue("COPY(SELECT 42 AS my_column) TO '{path}' (FORMAT 'parquet');")
  run_query(query)

  # Evaluate test results
  expect_no_error(metadata <- parquet_metadata(path))
  expect_equal(nrow(metadata), 1)
  expect_equal(metadata$path_in_schema[1], "my_column")
  expect_equal(metadata$stats_max_value[1], 42)

  # Tidy up
  file.remove(path)
})
