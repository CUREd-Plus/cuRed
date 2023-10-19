library(stringr)
library(readr)

#' Link the data set to the reference data.
#'
#' @param input_path Path of the source data file.
#' @param output_path String. Path of the merged data file.
#' @param patient_path String. Path of the patient ID bridge file.
#' @param demographics_path String. Path of the demographics data file.
#'
#' @export
#'
link <- function(input_path, output_path, patient_path, demographics_path) {
  # Get file paths
  input_path <- normalizePath(file.path(input_path), mustWork = TRUE)
  output_path <- normalizePath(file.path(output_path), mustWork = FALSE)
  patient_path <- normalizePath(file.path(patient_path), mustWork = TRUE)
  demographics_path <- normalizePath(file.path(demographics_path), mustWork = TRUE)

  # Build the linkage SQL query
  # Load the query template
  query_template_path <- normalizePath(system.file("extdata", "queries/linkage/apc.sql", package = "cuRed"), mustWork = TRUE)
  query_template <- readr::read_file(query_template_path)
  # Inject variable values into the SQL template
  query <- stringr::str_glue(query_template)

  # Write SQL query to text file
  query_path <- normalizePath(paste(output_path, "_query.sql", sep = ""), mustWork = FALSE)
  readr::write_file(query, query_path)

  # Execute the data operation
  run_query(query)

  cli::cli_alert_info("Wrote '{output_path}'")
}
