library(DBI)
library(duckdb)
        
test_that("extdata patient works", {
  # Test dummy patient ID data (in the inst/extdata directory)
  
  # Build path to data file
  patient_path <- input_path <- normalizePath(system.file("extdata", "patient_id_bridge.csv", package="cuRed"), mustWork = TRUE)
  
  # Check patients
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
  data <- DBI::dbGetQuery(con, stringr::str_glue("
SELECT *
FROM read_csv_auto('{patient_path}', header=true, all_varchar=true)
"))
  DBI::dbDisconnect(con, shutdown = TRUE)
  
  # Check the number of columns
  expect_equal(ncol(data), 3)
})
