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
#' @param raw_data_dir String. The directory that contains the raw data for this data set.
#' @param metadata_path String path. The technical output specificiation (TOS) file path.
#' @param staging_dir The directory to store working data files.
#'
run_workflow <- function(data_set_id, raw_data_dir, metadata_path, staging_dir) {
  # Cast parameters to the correct data type
  data_set_id <- as.character(data_set_id)

  # Ensure input directory exists
  raw_data_dir <- normalizePath(raw_data_dir, mustWork = TRUE)

  # Parse the TOS
  metadata <- parse_tos(metadata_path)

  # Convert to binary format
  csv_to_binary(
    raw_data_dir = raw_data_dir,
    output_data_dir = staging_dir,
    metadata = metadata,
    data_set_id = data_set_id
  )

  # Validate
  validate(staging_dir)

  # Generate summary report

  # Data linkage
  link(input_path = binary_path)

  # Cleaning

  # Generate metadata (column names, data types, descriptions)

  # Data quality rules (Flag "bad" records)

  # Generate data quality report

  # Generate FHIR data model
}
