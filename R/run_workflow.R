library(cli)

#' Run a data processing workflow for a single data set.
#'
#' @description
#' `run_workflow` executes the data pipeline for a single data set.
#'
#' @details
#' TODO
#' 
#' @export
#'
#' @param data_set_id String. Data set identifier e.g. "apc" or "op"
#' @param root_directry String. The root directory that contains all the data.
run_workflow <- function(data_set_id, root_directry) {
  # Cast parameters to the correct data type
  data_set_id <- as.character(data_set_id)
  root_directry <- file.path(root_directry)

  # Check whether the data directory exists
  if (!file.exists(root_directory)) {
    cli::cli_alert_warning("Directory doesn't exist '{root_directory}'")
    stop("Data directory not found")
  }

  cli::cli_alert_info("Root directory '{root_directory}'")

  # TODO
  # Parse the TOS
  tos_path <- file.path("/path/to/TOS.xlsx")
  # Get data types for each column

  # Define working directories
  data_set_dir <- file.path(root_directory, "/", data_set_id)
  raw_data_dir <- file.path(data_set_dir, "/01-raw")

  # Convert to binary format
  staging_dir <- csv_to_binary(raw_data_dir, metadata)

  # Validate

  # Generate summary report

  # Data linkage

  # Cleaning

  # Generate metadata (column names, data types, descriptions)

  # Data quality rules (Flag "bad" records)

  # Generate data quality report

  # Generate FHIR data model
}
