library(stringr)

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

  query <- stringr::str_glue("
    -- https://duckdb.org/docs/data/parquet/overview.html
    COPY (
      SELECT *
      FROM read_parquet('{input_path}')
    )
    TO '{output_path}'
    WITH (FORMAT 'PARQUET');")

  # Write SQL query to text file
  write_file(sql_query_file_path, query)

  # Execute the data operation
  run_query(query)
}
