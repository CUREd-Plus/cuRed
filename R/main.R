library(fs)
library(logger)


#' Run workflow
#'
#' @description
#' The function executes the entire data pipeline for the specified data set.
#'
#' @param data_set_id Character. Data set identifier e.g. "apc", "yas_epr", "op"
#' @param config_active Character. The specific [configuration](https://rstudio.github.io/config/articles/config.html) to use.
#'
#' @export
#'
main <- function(data_set_id, config_active = NA) {

  # Specify which configuration namespace to use
  if (is.na(config_active)) {
    config_active = Sys.getenv("R_CONFIG_ACTIVE", "default")
  }

  # Load global options
  # https://rstudio.github.io/config/reference/
  config_file_path <- extdata_path("config/config.yaml")
  logger::log_info("Loading '{config_file_path}' ('{config_active}' options)")
  config <- config::get(file = config_file_path, config = config_active)

  # Set up logs
  configure_logging(log_threshold = config$log_threshold, log_dir = config$log_dir)

  # Audit log
  username <- Sys.getenv("USERNAME")
  logger::log_info("User name '{username}'")

  # Load data set options
  data_set_config_file_path <- extdata_path(stringr::str_glue("config/{data_set_id}.yaml"))
  logger::log_info("Loading '{data_set_config_file_path}'")
  config = config::merge(config, config::get(file = data_set_config_file_path, , config = config_active))

  # Inform user what's happening
  logger::log_info("Running workflow for data set '{data_set_id}'")

  # Run the workflow for this data set
  run_workflow(
    data_set_id = config$id,
    raw_data_dir = config$raw_data_dir,
    metadata_path = config$metadata_path,
    sheet = config$sheet,
    staging_dir = config$staging_dir,
    patient_path = config$patient_path,
    demographics_path = config$demographics_path
  )
}


#' @title Configure logging for the data pipeline.
#'
#' @description
#' Configure logging using the [logger](https://daroczig.github.io/logger/) package.
#'
#' @param log_threshold The minimum log level to be recorded. Valid values are "TRACE", "DEBUG", "INFO", "WARN", "ERROR", and "FATAL". The default is "INFO".
#' @param log_dir The directory where the log file will be stored. If not provided, the log file will be stored in the temporary directory.
#'
#' @examples
#' configure_logging(log_threshold = "DEBUG")
#' configure_logging(log_dir = "C:/Users/Administrator/logs")
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
