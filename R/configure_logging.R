library(fs)
library(logger)


#' @title Configure logging for the data pipeline.
#'
#' @description
#' Configure logging using the [logger](https://daroczig.github.io/logger/) package.
#'
#' @param log_threshold The minimum log level to be recorded. Valid values are "TRACE", "DEBUG", "INFO", "WARN", "ERROR", and "FATAL". The default is "INFO".
#' @param log_dir The directory where the log file will be stored. If not provided, the log file will be stored in the temporary directory.
#'
configure_logging <- function(log_threshold = "INFO", log_dir = NA) {

  # Default log file location
  if (is.na(log_dir)) {
    log_dir = temp_dir()
  }

  # Set log level
  logger::log_threshold(log_threshold)

  # Create log directory
  fs::dir_create(log_dir, recurse = TRUE)

  # Build log file path
  # e.g. "C:\Users\Administrator\2023-06-31.log"
  log_file_name <- paste(Sys.Date(), ".log", sep = "")  # e.g. "2023-06-31.log"
  log_file <- fs::path(log_dir, log_file_name)

  logger::log_info("Logging to file '{log_file}'")

  # Configure logging
  # Output to standard output and to file
  logger::log_appender(logger::appender_tee(log_file))
}
