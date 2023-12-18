library(fs)
library(logger)
library(stringr)


#' Run the data pipeline for a single data set.
#'
#' @description
#' `run_workflow` executes the data pipeline for a single data set.
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
#' @param clean_dir Path of the output directory for clean data.
#'
run_workflow <- function(data_set_id, raw_data_dir, metadata_path, sheet, staging_dir, patient_path, patient_key, demographics_path, clean_dir) {
  # Cast parameters to the correct data type
  data_set_id <- as.character(data_set_id)

  # Ensure input directory exists
  raw_data_dir <- normalizePath(raw_data_dir, mustWork = TRUE)
  patient_path <- normalizePath(patient_path, mustWork = TRUE)
  staging_dir <- normalizePath(staging_dir, mustWork = FALSE)

  # Convert files to binary format (one file per table)
  binary_paths <- csv_to_binary(
    input_dir = raw_data_dir,
    output_dir = staging_dir,
    data_set_id = data_set_id
  )

  # Paths of clean data file
  output_paths <- character()

  # Iterate over the binary file paths
  for (i in seq_len(length(binary_paths))) {
    binary_path <- binary_paths[[i]]
    # Assume the table identifier is the file name without the file extension
    # e.g. "C:\Users\Administrator\raw\yas_epr\incident.parquet" -> "incident"
    table_id <- tools::file_path_sans_ext(basename(binary_path))
    logger::log_info("Processing table '{table_id}' from data set '{data_set_id}'")

    # Validate
    rules_path <- extdata_path(stringr::str_glue("validation_rules/{data_set_id}/{table_id}.yaml"))
    validate_data(data_path = binary_path, rules_path = rules_path)

    # Generate summary report
    summary_function(data_path)
    generate_summary_report("C:/Users/Administrator/R/summary.R", "inst/extdata/summary_reports/{data_set_id}/{table_id}.html")

    # Data linkage
    link(
      data_set_id = data_set_id,
      input_path = binary_path,
      output_path = output_path,
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

    output_paths = append(output_paths, output_path)
  }

  # Move clean data set to the output directory
  # Make a subdirectory for this data set
  clean_dir = fs::path(clean_dir, data_set_id)
  fs::dir_create(clean_dir)
  # Iterate over tables
  for (output_path in output_paths) {
    clean_path = fs::path(clean_dir, stringr::str_glue("{data_set_id}_{table_id}.parquet"))
    fs::file_move(output_path, clean_path)
    logger::log_success("Moved '{output_path}' to '{clean_path}'")
  }

  # Finish
  logger::log_success("Completed workflow for '{data_set_id}' data set")
}
