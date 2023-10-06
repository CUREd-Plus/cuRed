test_that("Convert JSON data to an SQL struct", {
  data <- '{"key": "value"}'

  struct <- convert_json_to_struct(data)

  correct_struct <- "{'key': 'value'}"

  expect_equal(struct, correct_struct)
})
