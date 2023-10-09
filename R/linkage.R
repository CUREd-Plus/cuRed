library(stringr)
library(readr)

#' Link the data set to the reference data.
#'
#' @param input_path Source Parquet file path.
#' @param output_path Target Parquet file path.
#'
#' @export
#'
link <- function(input_path, output_path) {
  input_path <- normalizePath(file.path(input_path), mustWork = TRUE)
  sql_query_file_path <- normalizePath(file.path(output_path, "../linkage_query.sql"), mustWork = FALSE)

  query_path <- normalizePath(system.file("extdata", "queries/linkage/apc.sql", package = "cuRed"), mustWork = TRUE)
  # https://readr.tidyverse.org/reference/read_file.html
  query_template <- readr::read_file(query_path)
  query <- stringr::str_glue(query_template)

  # Write SQL query to text file
  readr::write_file(query, sql_query_file_path)

  # Execute the data operation
  run_query(query)
}
