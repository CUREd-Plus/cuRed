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
  audit()

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
    demographics_path = config$demographics_path,
    clean_dir = config$clean_dir
  )
}

