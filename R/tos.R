<<<<<<< HEAD
=======
library(cli)
library(dplyr)
>>>>>>> main
library(readxl)

#' Parse Technical Output Specification (TOS) metadata file.
#'
#' @param xls_file character. Path File to Excel file from which TOS are to be loaded.
#' @param sheet character. Name of worksheet to be loaded.
#' @export
#' @returns data.frame TOS metadata
#'
<<<<<<< HEAD
parse_tos <- function(xls_file, sheet = "HES APC TOS", sheet_number = NA) {
=======
parse_tos <- function(xls_file, sheet) {

  # Use the readxl package
  # https://readxl.tidyverse.org/reference/read_excel.html
>>>>>>> main
  myCols <- as.character(readxl::read_excel(xls_file, sheet, n_max = 1, skip = 1, col_names = FALSE))
  # Get data only and attached the cols names
  var_list <- c("Field", "Field name", "Format", "Availability", "Values")
  my_data <- readxl::read_excel(xls_file, sheet, skip = 2, col_names = myCols)
<<<<<<< HEAD
  my_data2 <- select(my_data, all_of(var_list))
=======
  my_data2 <- dplyr::select(my_data, dplyr::all_of(var_list))
>>>>>>> main
  # Remove empty rows
  my_data2 <- my_data2[!apply(my_data2 == "", 1, all), ]
  # Remove rows that contains NA only, nothing else.
  my_data2 <- my_data2[rowSums(is.na(my_data2)) != ncol(my_data2), ]
  return(my_data2)
}

#' Serialise a data frame to a JSON file.
#'
#' @param df data.frame Data frame.
#' @param outputdir character. Path. Output directory.
#' @param json_file character. Path. File name for the JSON file.
#' @export
df2json <- function(df, outputdir, json_file) {
  # Create output directory if it doesn't exist
  if (!dir.exists(file.path(outputdir))) {
    dir.create(outputdir, showWarnings = FALSE, recursive = TRUE)
  }
  # Build path
  path <- file.path(outputdir, json_file)
  # Serialise
  jsonlite::write_json(df, path)
  cli::cli_alert_info("Wrote '{path}'")
}
