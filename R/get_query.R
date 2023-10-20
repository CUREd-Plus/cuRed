library(DBI)
library(duckdb)

#' Get SQL query result using the [DuckDB R API](https://duckdb.org/docs/api/r.html)
#'
#' @param query String. SQL query.
#'
#' @returns Data frame containing query results.
#'
#' @export
#'
get_query <- function(query) {
  # Connect to an in-memory database
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")

  # Run the query
  # https://duckdb.org/docs/api/r.html
  data <- DBI::dbGetQuery(con, query)

  # Close the database connection
  DBI::dbDisconnect(con, shutdown = TRUE)

  return(data)
}
