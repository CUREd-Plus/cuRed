#' Get SQL query result
#' @param query String. SQL query.
#' @returns Data frame containing query results.
#' @export
get_query <- function(query) {
  # Connect to an in-memory database
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
  
  # Run the query
  data <- DBI::dbGetQuery(con, query)
  
  # Close the database connection
  DBI::dbDisconnect(con, shutdown = TRUE)
  
  return(data)
}
