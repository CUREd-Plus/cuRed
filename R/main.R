library(cli)

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

  # Audit log
  cured_version <- utils::packageVersion("cuRed")
  current_timestamp <- Sys.time()
  cli::cli_inform("{current_timestamp} running cuRed package version {cured_version}")

  # Load global options
  # https://rstudio.github.io/config/reference/
  config_file_path <- extdata_path("config/config.yaml")
  cli::cli_alert_info("Loading '{config_file_path}'")
  config <- config::get(file = config_file_path, use_parent = FALSE)

  # Load data set options
  data_set_config_file_path <- extdata_path(stringr::str_glue("config/{data_set_id}.yaml"))
  cli::cli_alert_info("Loading '{data_set_config_file_path}'")
  config = config::merge(config, config::get(file = data_set_config_file_path))

  # Inform user what's happening
  cli::cli_alert_info("Running workflow for data set '{data_set_id}'")

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
