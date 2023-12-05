library(logger)

#' Run workflow
#'
#' @description
#' The function executes the entire data pipeline for the specified data set.
#'
#' @param data_set_id character. Data set identifier e.g. "apc", "yas_epr", "op"
#'
#' @export
#'
main <- function(data_set_id) {

  # Load global options
  # https://rstudio.github.io/config/reference/
  config_file_path <- extdata_path("config/config.yaml")
  logger::log_info("Loading '{config_file_path}'")
  config <- config::get(file = config_file_path, use_parent = FALSE)

  # Load data set options
  data_set_config_file_path <- extdata_path(stringr::str_glue("config/{data_set_id}.yaml"))
  logger::log_info("Loading '{data_set_config_file_path}'")
  config = config::merge(config, config::get(file = data_set_config_file_path))

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
