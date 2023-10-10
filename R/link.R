library(stringr)
library(readr)

#' Link the data set to the reference data.
#'
#' @param input_path Source Parquet file path.
#' @param output_path Target Parquet file path.
#' @param patient_path String. Path to the patient ID bridge file.
#'
#' @export
#'
link <- function(input_path, output_path, patient_path, demographics_path, deaths_path) {
  # Get file paths
  input_path <- normalizePath(file.path(input_path), mustWork = TRUE)
  output_path <-  normalizePath(file.path(output_path), mustWork = FALSE)
  patient_path <- normalizePath(file.path(patient_path), mustWork = TRUE)
  demographics_path <- normalizePath(file.path(demographics_path), mustWork = TRUE)
  deaths_path <- normalizePath(file.path(deaths_path), mustWork = TRUE)
  query_template_path <- normalizePath(system.file("extdata", "queries/linkage/apc.sql", package = "cuRed"), mustWork = TRUE)
  query_path <- normalizePath(paste(output_path, "query.sql", sep=""), mustWork = FALSE)

  # Build the linkage SQL query
  query_template <- readr::read_file(query_template_path)
  # Inject variable values into the SQL template
  query <- stringr::str_glue(query_template)

  # Write SQL query to text file
  readr::write_file(query, query_path)

  # Execute the data operation
  run_query(query)
}
