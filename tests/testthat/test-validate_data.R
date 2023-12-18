library(logger)

test_that("Validate APC", {

  working_dir <- temp_dir()
  # Tidy up temporary files on exit or failure
  on.exit(unlink(working_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  # Use the dummy data
  data_path <- extdata_path("data/apc/artificial_hes_apc_0102_truncated.parquet")
  rules_path <- extdata_path("validation_rules/apc/apc.yaml")

  # Run the data validation task
  expect_no_error(
    results <- validate_data(
      data_path = data_path,
      rules_path = rules_path,
      output_dir = working_dir
    )
  )
})
