library(logger)

#' Record an audit log
audit <- function() {
  username <- Sys.getenv("USERNAME")
  logger::log_info("User name '{username}'")
  cured_version <- utils::packageVersion("cuRed")
  logger::log_info("Running CUREd+ package version {cured_version}")
}
