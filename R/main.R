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

  load_config(data_set_id = data_set_id, active_config = active_config, config_path = config_path, data_set_config_path = data_set_config_path)
  configure_logging(log_threshold = config$log_threshold, log_dir = config$log_dir)
  audit()

  if (is.na(data_set_id)) { data_set_id = config$id }

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
