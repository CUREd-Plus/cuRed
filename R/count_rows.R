
#' Count the number of rows in the input data set.
#'
#' @param path character File path of a Parquet file.
#' @param read_func character, name of DuckDB function that loads the file e.g. "read_csv_auto", "read_parquet"
#'
#' @export
#'
#' @returns integer number of rows in the input data file.
#'
count_rows <- function(path, read_func = "read_csv_auto") {

  # Run the SQL query
  query <- stringr::str_glue("SELECT COUNT(*) FROM {read_func}('{path}')")
  result <- get_query(query)

  # Return the row count
  count <- as.integer(result[[1]])
  return(count)
}
