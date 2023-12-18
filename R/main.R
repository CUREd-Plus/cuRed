library(fs)
library(logger)


#' Run workflow
#'
#' @description
#' The function executes the entire data pipeline for the specified data set.
#'
#' One of `data_set_id` OR `data_set_config_path` are required.
#'
#' This code will load all the configuration files and configure logging, etc.
#'
#' @param data_set_id Data set identifier e.g. "apc", "yas_epr", "op". Default: Load `id` value from `data_set_config_path`.
#' @param active_config The specific [configuration](https://rstudio.github.io/config/articles/config.html) to use. Default: "default"
#' @param config_path Path of the global configuration file. Default: "extdata/config/config.yaml".
#' @param data_set_config_path Path of the data set configuration file. Default: "extdata/config/{data_set_id}.yaml".
#'
#' @export
#'
main <- function(data_set_id = NA, active_config = NA, config_path= NA, data_set_config_path = NA) {

  # Specify which configuration namespace to use
  if (is.na(active_config)) {
    active_config = Sys.getenv("R_active_config", "default")
  }

  # Load global options
  # https://rstudio.github.io/config/reference/
  if (is.na(config_path)) {
    config_path = extdata_path("config/config.yaml")
  }
  logger::log_info("Loading '{config_path}' ('{active_config}' options)")
  config <- config::get(file = config_path, config = active_config)

  # Set up logs
  configure_logging(log_threshold = config$log_threshold, log_dir = config$log_dir)

  # Audit log
  username <- Sys.getenv("USERNAME")
  logger::log_info("User name '{username}'")
  cured_version <- utils::packageVersion("cuRed")
  logger::log_info("Running CUREd+ package version {cured_version}")

  # Load data set options
  if (is.na(data_set_config_path)) {
    data_set_config_path <- extdata_path(stringr::str_glue("config/{data_set_id}.yaml"))
  }
  logger::log_info("Loading '{data_set_config_path}'")
  config = config::merge(config, config::get(file = data_set_config_path, config = active_config))

  if (is.na(data_set_id)) {
    data_set_id = config$id
  }

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
    demographics_path = config$demographics_path,
    clean_dir = config$clean_dir
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
