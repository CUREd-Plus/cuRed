#' Append historic address
#' 
#' @description
#' This function is used to merge the historic address data.
#' 
#'
#' @param input_path character. Path of the source data file.
#' @param address_path character. Path of the historic address data file.
#' @param output_path character. Path of the destination data file.
#' @param date_column character. The name of the field in the source data that contains the date.
#' 
#' @return character. Path of output data file.
#'
historic_address <- function(input_path, address_path, output_path, date_column) {
  
  # Get file paths
  input_path <- normalizePath(input_path, mustWork = TRUE)
  address_path <- normalizePath(address_path, mustWork = TRUE)
  output_path <- normalizePath(output_path, mustWork = FALSE)
  
  # Build SQL query using a template
  query_template_path <- extdata_path(stringr::str_glue("queries/linkage/address.sql"))
  query_template <- readr::read_file(query_template_path)
  query <- stringr::str_glue(query_template)
  
  # Write SQL query to text file
  query_path <- paste(output_path, ".sql", sep = "")
  readr::write_file(query, query_path)
  cli::cli_alert_info("Wrote '{query_path}'")
  
  # Execute the data operation
  run_query(query)
  
  # Inform the user that the SQL query file has been written
  cli::cli_alert_success("Wrote '{output_path}'")
  
  return(output_path)
}
