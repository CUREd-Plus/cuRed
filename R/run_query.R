library(DBI)
library(duckdb)

#' Run a DuckDB query
#'
#' @param query Structured Query Language (SQL) https://duckdb.org/docs/sql/introduction
#'
#' @returns The number of rows affected by the query.
#'
#' @export
#'
run_query <- function(query) {
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
  on.exit(DBI::dbDisconnect(con), add = TRUE, after = FALSE)

  # Error messages may appear after the query itself, so you might need to truncate the query.

  # Run the query
  # TODO https://dbi.r-dbi.org/reference/dbgetquery
  affected_rows_count <- DBI::dbExecute(con, query)
  cli::cli_alert_info("{affected_rows_count} rows affected")

  return(as.integer(affected_rows_count))
}

#' Get SQL query result using the [DuckDB R API](https://duckdb.org/docs/api/r.html)
#'
#' @param query String. SQL query.
#'
#' @returns Data frame containing query results.
#'
#' @export
#'
get_query <- function(query) {

  con <- connect()

  # Run the query
  # https://duckdb.org/docs/api/r.html
  data <- DBI::dbGetQuery(con, query)

  return(data)
}


#' Connect to database
connect <- function(dbdir = ":memory:", ..) {

  # Connect to an in-memory database
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = dbdir, ..)
  on.exit(DBI::dbDisconnect(con), add = TRUE, after = FALSE)

  return(con)
}
