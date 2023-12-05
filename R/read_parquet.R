library(logger)
library(stringr)


#' Load an Apache Parquet file into an R data frame.
#'
#' @description
#' This function uses the DuckDB [read_parquet()](https://duckdb.org/docs/data/parquet/overview#read_parquet-function)
#' function.
#'
#' @param path Character. Source data file
#'
#' @returns data.frame Data file contents.
#' @export
read_parquet <- function(path) {
  query <- stringr::str_glue("SELECT * FROM read_parquet('{path}')")
  data <- get_query(query)
  logger::log_info("Loaded '{path}'")

  return(data)
}

#' Read [Parquet metadata](https://duckdb.org/docs/data/parquet/metadata.html)
#'
#' @param path Character Input data file path.
#'
#' @returns data.frame. Column descriptions for the input data file.
#' @export
parquet_metadata <- function(path) {
  query <- stringr::str_glue("SELECT * FROM parquet_metadata('{path}')")
  metadata <- get_query(query)
  return(metadata)
}
