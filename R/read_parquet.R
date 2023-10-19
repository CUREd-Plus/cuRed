#' Load an Apache Parquet file into an R data frame.
#'
#' https://duckdb.org/docs/data/parquet/overview#read_parquet-function
#'
#' @param file_path String. Source data file path.
#' @export
#' @returns data.frame Data file contents.
read_parquet <- function(file_path) {
  # Check file exists
  file_path <- normalizePath(file.path(file_path), mustWork = TRUE)

  # Parse Parquet file
  query <- stringr::str_glue("SELECT * FROM read_parquet('{file_path}')")
  data <- get_query(query)

  return(data)
}
