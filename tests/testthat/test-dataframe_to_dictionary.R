test_that("dataframe_to_dictionary", {
  data_frame <- data.frame(name = c("Alice", "Bob", "Charlie"), age = c(30, 25, 42))
  dictionary <- dataframe_to_dictionary(data_frame, key_col = "name", value_col = "age")

  expected_dictionary <- list("Alice" = 30, "Bob" = 25, "Charlie" = 42)
  expect_equal(dictionary, expected_dictionary)
})
