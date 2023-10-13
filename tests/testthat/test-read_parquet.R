test_that("read_parquet works", {
  file_path <- extdata_path("artificial_hes_apc_0102.parquet")
  expect_no_error(
    read_parquet(file_path)
  )
})
