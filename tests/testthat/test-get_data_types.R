library(testthat)
library(jsonlite)

test_that("Get the SQL data type for each field in a data set", {
  # Run the function with example metadata
  metadata_json <- '[{"Field": "ADMIDATE", "Format": "Date(YYYY-MM-DD)"}]'
  metadata <- as.data.frame(jsonlite::fromJSON(metadata_json))
  field_names <- get_data_types(metadata = metadata, data_set_id = "apc")

  # Evaluate result
  correct_field_names <- list(ADMIDATE = "DATE")
  testthat::expect_equal(field_names, correct_field_names)
})
