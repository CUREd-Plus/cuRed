test_that("validate works", {
  # Use the dummy data
  data_path <- extdata_path("artificial_hes_apc_0102.parquet")
  rules_path <- extdata_path("validation_rules/apc.yaml")

  # Run the data validation task
  expect_no_error(
    validate(data_path = data_path, rules_path = rules_path)
  )
})
