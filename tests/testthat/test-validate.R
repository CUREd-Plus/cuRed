test_that("validate works", {
  # Use the dummy data
  data_path <- normalizePath(system.file("extdata", "artificial_hes_apc_0102.parquet", package = "cuRed"), mustWork = TRUE)
  rules_path <- normalizePath(system.file("extdata", "validation_rules/apc.yaml", package = "cuRed"), mustWork = TRUE)

  # Run the data validation task
  expect_no_error(
    validate(data_path = data_path, rules_path = rules_path)
  )
})
