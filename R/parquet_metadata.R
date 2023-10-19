#' Read Parquet metadata
#' https://duckdb.org/docs/data/parquet/metadata.html
#'
#' @param file_path String. Input data file path.
#'
#' @returns Table of column descriptions from the input data file.
#'
#' @export
#'
parquet_metadata <- function(file_path) {
  query <- stringr::str_glue("SELECT * FROM parquet_metadata('{file_path}')")
  metadata <- get_query(query)
  return(metadata)
}
