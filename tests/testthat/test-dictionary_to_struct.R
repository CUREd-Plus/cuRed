test_that("dictionary_to_struct", {
  dictionary <- c("key" = "value")
  struct <- dictionary_to_struct(dictionary = dictionary)
  expected_struct <- "{'key': 'value'}"
  expect_equal(struct, expected_struct)
})
