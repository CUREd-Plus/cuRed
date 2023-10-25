library(DBI)
library(duckdb)

#' Execute a DuckDB query that doesn't return a result.
#'
#' @param query Structured Query Language (SQL) https://duckdb.org/docs/sql/introduction
#'
#' @returns The number of rows affected by the query.
#'
#' @export
#'
run_query <- function(query) {
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE, after = FALSE)

  # Error messages may appear after the query itself, so you might need to truncate the query.

  # Execute the query
  # https://dbi.r-dbi.org/reference/dbexecute
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
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE, after = FALSE)

  # Run the query
  # https://duckdb.org/docs/api/r.html
  data <- DBI::dbGetQuery(con, query)

  return(data)
}


#' Connect to database
#'
#' @description
#' See [DuckDB R API](https://duckdb.org/docs/api/r.html)
#'
#' We want an in-memory database.
#'
#' @param dbdir The location of the database, default :memory:
#' @param ... Arguments to DBI::dbConnect(...)
#' @returns Database connection handle
#' @export
connect <- function(dbdir = ":memory:", ...) {

  # Connect to an in-memory database
  # https://dbi.r-dbi.org/reference/dbconnect
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = dbdir, ...)

  return(con)
}
