library(cli)
library(stringr)

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
#' @param data_set_id character Data set identifier e.g. "apc" or "op"
#' @param raw_data_dir character The directory that contains the raw data for this data set.
#' @param metadata_path character Path of the technical output specification (TOS) workbook file path.
#' @param sheet character Name of the sheet (tab) in the TOS workbook
#' @param staging_dir character The directory to store working data files.
#' @param patient_path character Path of the patient identifier bridge data file.
#' @param patient_key The column name of the foreign key to link to the patient ID bridge data set.
#' @param demographics_path character Path of the demographics file.
#'
run_workflow <- function(data_set_id, raw_data_dir, metadata_path, sheet, staging_dir, patient_path, patient_key, demographics_path) {
  # Cast parameters to the correct data type
  data_set_id <- as.character(data_set_id)

  # Ensure input directory exists
  raw_data_dir <- normalizePath(raw_data_dir, mustWork = TRUE)
  patient_path <- normalizePath(patient_path, mustWork = TRUE)
  staging_dir <- normalizePath(staging_dir, mustWork = FALSE)
  linked_path <- file.path(staging_dir, stringr::str_glue("03-{data_set_id}_linked.parquet"))

  # Convert files to binary format
  binary_paths <- csv_to_binary(
    input_dir = raw_data_dir,
    output_dir = staging_dir,
    data_set_id = data_set_id
  )

  # Iterate over the binary file paths
  for (i in seq_len(length(binary_paths))) {
    binary_path <- binary_paths[[i]]
    table_id <- tools::file_path_sans_ext(binary_path)

    # Validate
    rules_path <- extdata_path(stringr::str_glue("validation_rules/{data_set_id}/{table_id}.yaml"))
    validate_data(data_path = binary_path, rules_path = rules_path)

    # Generate summary report
    # TODO

    # Data linkage
    link(
      data_set_id = data_set_id,
      input_path = binary_path,
      output_path = linked_path,
      patient_path = patient_path,
      demographics_path = demographics_path,
      patient_key = patient_key
    )

    # Cleaning
    # TODO

    # Generate metadata (column names, data types, descriptions)
    # TODO

    # Data quality rules (Flag "bad" records)
    # TODO

    # Generate data quality report
    # TODO

    # Generate FHIR data model
    # TODO
  }

  # Finish
  cli::cli_alert_success("Completed workflow for '{data_set_id}' data set")
}
