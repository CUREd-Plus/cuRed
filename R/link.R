library(logger)
library(stringr)
library(readr)

#' Link the data set to the reference data.
#'
#' @description
#' See `R/link.md` for more information about this function.
#'
#' @param data_set_id character. Data set identifier e.g. "apc", "ae", "op"
#' @param input_path character. Path of the source data file.
#' @param output_path character. Path of the merged data file.
#' @param patient_path character. Path of the patient ID bridge file.
#' @param demographics_path character. Path of the demographics data file.
#' @param patient_key character. Foreign key column name that links the data set to the patient ID bridge, e.g. "token_person_id"
#'
#' @return character. Path of output file.
#'
#' @export
#'
link <- function(data_set_id, input_path, output_path, patient_path, demographics_path, patient_key) {
  # Get file paths
  input_path <- normalizePath(input_path, mustWork = TRUE)
  output_path <- normalizePath(output_path, mustWork = FALSE)
  patient_path <- normalizePath(patient_path, mustWork = TRUE)
  demographics_path <- normalizePath(demographics_path, mustWork = TRUE)

  # Build SQL for "SELECT {fields_sql}"
  # Get the names of all fields in the input data set
  fields <- parquet_metadata(input_path)$path_in_schema
  fields <- paste(data_set_id, ".", fields, sep = "")
  fields_sql <- paste(fields, collapse = "\n    ,")

  # Build the linkage SQL query
  # Load the query template
  query_template_path <- extdata_path(stringr::str_glue("queries/linkage/{data_set_id}.sql"), mustWork = FALSE)
  if (!file.exists(query_template_path)) {
    # Default SQL query (may or may not work for all data sets)
    query_template_path = extdata_path(stringr::str_glue("queries/linkage/linkage.sql"))
  }
  query_template <- readr::read_file(query_template_path)
  # Inject variable values into the SQL template
  query <- stringr::str_glue(query_template)

  # Write SQL query to text file
  query_path <- paste(output_path, ".sql", sep = "")
  readr::write_file(query, query_path)
  logger::log_info("Wrote '{query_path}'")

  # Execute the data operation
  run_query(query)

  # Inform the user that the SQL query file has been written
  logger::log_info("Wrote '{output_path}'")

  return(output_path)
}
