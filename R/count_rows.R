#' Count the number of rows in the input data set.
#'
#' @param path character File path of a Parquet file.
#' @param read_func character, name of DuckDB function that loads the file
#'
#' @export
#'
#' @returns The number of rows in the input data file.
#'
count_rows <- function(path, read_func = "read_parquet") {
  query <- stringr::str_glue("SELECT COUNT(*) FROM {read_func}('{path}')")
  result <- get_query(query)
  count <- as.integer(result[[1]])
  return(count)
}
