library(cli)
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
#' @param query character. SQL query
#' @param read_only logical. If true, use READ_ONLY access mode
#'
#' @returns Data frame containing query results.
#'
#' @export
#'
get_query <- function(query, read_only = FALSE) {

  con <- connect()
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE, after = FALSE)

  # Read-only mode
  if (read_only) {
    query <- "SET access_mode='READ_ONLY';"
    DBI::dbExecute(con, query)
  }

  # Run the query
  # https://duckdb.org/docs/api/r.html
  data <- DBI::dbGetQuery(con, query)

  return(data)
}


#' Connect to database
#' https://duckdb.org/docs/api/r.html
#' https://dbi.r-dbi.org/reference/dbconnect
#' @param dbdir The location of the database, default :memory:
#' @param ... Arguments to DBI::dbConnect(...)
#' @returns Database connection handle
#' @export
connect <- function(dbdir = ":memory:", ...) {

  # Connect to an in-memory database
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = dbdir, ...)

  return(con)
}


#' Configure database connection
#'
#' See: [DuckDB Configuration](https://duckdb.org/docs/sql/configuration.html)
#'
#' @param con DBI::DBIConnection
#' @param log_query_path character. Path to which queries should be logged
#'
#' @return DBI::DBIConnection
#' @export
#'
configure_connection <- function(con, log_query_path=NA) {

  if (is.na(log_query_path)) {
    # Write to log file in temp dir
    log_query_path = file.path(tempdir(check = TRUE), "queries.log")
  }

  # Load query
  query_path <- extdata_path("queries/configure_connection.sql")
  query_template <- readr::read_file(query_path)
  query <- stringr::str_glue(query_template)

  DBI::dbExecute(con, query)

  return(con)
}
