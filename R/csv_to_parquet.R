#' Convert CSV to Parquet format
#' 
#' This doesn't convert data types, but assumes every column contains
#' strings.
#' 
#' @param input_path String. Source data file location.
#' @param output_path String. Target data file location.
#' 
csv_to_parquet <- function(input_path, output_path) {
  
  # Build SQL query
  query_path <- normalizePath(system.file("extdata", "queries/csv_to_parquet.sql", package = "cuRed"), mustWork = TRUE)
  query_template <- readr::read_file(query_path)
  query <- stringr::str_glue(query_template)
  
  # Execute
  run_query(query)
}
