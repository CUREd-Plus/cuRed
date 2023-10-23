library(stringr)

test_that("parquet_metadata works", {
  # Generate dummy data
  test_dir <- temp_dir()
  on.exit(unlink(test_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
  path <- tempfile(fileext = ".parquet", tmpdir = test_dir)
  query <- stringr::str_glue("COPY(SELECT CAST(42 AS INT) AS my_column) TO '{path}' (FORMAT 'parquet');")
  run_query(query)

  # Evaluate test results
  expect_no_error(metadata <- parquet_metadata(path))
  expect_equal(nrow(metadata), 1)
  expect_equal(metadata$path_in_schema[1], "my_column")
})
