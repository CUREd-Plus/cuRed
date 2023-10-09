library(DBI)
library(duckdb)

#' Run a DuckDB query
#'
#' @param query Structured Query Language (SQL) https://duckdb.org/docs/sql/introduction
#'
#' @returns The number of rows affected by the query.
#'
run_query <- function(query) {
  # https://duckdb.org/docs/api/r
  # https://dbi.r-dbi.org/

  # Create an in-memory database connection
  # https://duckdb.org/docs/connect
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")

  # Run the query
  # TODO https://dbi.r-dbi.org/reference/dbgetquery
  affected_rows_count <- DBI::dbExecute(con, query)
  cli::cli_alert_info("{affected_rows_count} rows affected")

  DBI::dbDisconnect(con, shutdown = TRUE)

  return(as.integer(affected_rows_count))
}
