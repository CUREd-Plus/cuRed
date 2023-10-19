test_that("get_query works", {
  the_answer <- 42

  query <- stringr::str_glue("SELECT {the_answer} AS my_column")
  results <- get_query(query)

  # Check for a single row
  expect_equal(nrow(results), 1)

  # Check the value is the same
  expect_equal(results$my_column[1], the_answer)
})
