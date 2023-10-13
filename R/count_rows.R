#' Count the number of rows in the input data set.
#'
#' @param path String. File path of a Parquet file.
count_rows <- function(path) {
  query <- stringr::str_glue("SELECT COUNT(*) FROM read_parquet('{path}')")
  count <- get_query(query)
  count <- as.integer(apc_rows[[1]])
  return(count)
}
