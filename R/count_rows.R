#' Count the number of rows in the input data set.
#'
#' @param path character File path of a Parquet file.
#'
#' @export
#'
#' @returns The number of rows in the input data file.
#'
count_rows <- function(path) {
  query <- stringr::str_glue("SELECT COUNT(*) FROM read_parquet('{path}')")
  result <- get_query(query)
  count <- as.integer(result[[1]])
  return(count)
}
