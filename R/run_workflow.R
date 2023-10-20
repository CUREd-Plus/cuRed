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
#' @param demographics_path character Path of the demographics file.
#' 
run_workflow <- function(data_set_id, raw_data_dir, metadata_path, sheet, staging_dir, patient_path, demographics_path) {
  # Cast parameters to the correct data type
  data_set_id <- as.character(data_set_id)
  
  # Ensure input directory exists
  raw_data_dir <- normalizePath(raw_data_dir, mustWork = TRUE)
  patient_path <- normalizePath(patient_path, mustWork = TRUE)
  staging_dir <- normalizePath(staging_dir, mustWork = FALSE)
  output_path <- normalizePath(file.path(staging_dir, "linked.parquet"), mustWork = FALSE)
  
  # Parse the TOS
  metadata <- parse_tos(metadata_path, sheet = sheet)
  
  # Convert to binary format
  binary_path <- csv_to_binary(
    raw_data_dir = raw_data_dir,
    output_data_dir = staging_dir,
    metadata = metadata,
    data_set_id = data_set_id
  )
  
  # Validate
  rules_path <- extdata_path(stringr::str_glue("validation_rules/{data_set_id}.yaml"))
  validate(data_path = staging_dir, rules_path = rules_path)
  
  # Generate summary report
  
  # Data linkage
  link(
    input_path = binary_path,
    output_path = output_path,
    patient_path = patient_path,
    demographics_path = demographics_path
  )
  
  # Cleaning
  
  # Generate metadata (column names, data types, descriptions)
  
  # Data quality rules (Flag "bad" records)
  
  # Generate data quality report
  
  # Generate FHIR data model
}
