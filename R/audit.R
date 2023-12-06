library(logger)

#' @title Create an audit log
#'
#' @description
#' Write the current context of this operation.
#'
audit <- function() {
  # Record the current user name
  username <- Sys.getenv("USERNAME")
  logger::log_info("User name '{username}'")
}
