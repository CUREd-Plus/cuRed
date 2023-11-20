library(cli)
library(validate)

#' Validate a data set
#'
#' @description
#' This uses the [validate](https://cran.r-project.org/web/packages/validate/) package.
#'
#' Please read the [data validation cookbook](https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html).
#'
#' @param data_path character. Path of input data file.
#' @param rules_path character. Validation rules file path.
#' @param output_dir character. Path of directory to save results.
#'
#' @export
validate_data <- function(data_path, rules_path, output_dir=NA) {
  # Get file paths
  data_path <- normalizePath(data_path, mustWork = TRUE)
  rules_path <- normalizePath(rules_path, mustWork = TRUE)
  if (is.na(output_dir)) {
    output_dir <- temp_dir()
  }

  # Load rule set from a YAML file
  data_validator <- validate::validator(.file = rules_path)
  cli::cli_inform("Loaded rules from '{rules_path}'")

  # Load data
  data <- read_parquet(data_path)
  cli::cli_inform("Loaded data from '{data_path}'")

  # Run the data validation checks
  results <- validate::confront(dat = data, x = data_validator)

  # Log errors
  validation_errors <- validate::errors(results)
  for (key in names(validation_errors)) {
    value <- validation_errors[[key]]
    cli::cli_alert_danger("Validation error in rule '{key}': {value}")
  }

  # Save summary to a CSV file
  filename <- paste(basename(data_path), ".validation.csv", sep = "")
  results_summary_path <- file.path(output_dir, filename)
  serialise_validation(results, path = results_summary_path)

  # Save summary plot to PDF file
  filename <- paste(basename(data_path), ".validation.pdf", sep = "")
  plot_path <- file.path(output_dir, filename)
  #serialise_validation_plot(results, path = plot_path)

  return(results)
}

#' Is this a valid date
#'
#' @description
#' Compare an object's string representation to [ISO 8601 date](https://en.wikipedia.org/wiki/ISO_8601#Dates).
#'
#' @param x Input object to check
#'
#' @return logical. If TRUE, this is a valid date.
#' @export
#'
#' @examples
#' date_format("1970-01-01")
#'
date_format <- function(x) {
  # https://en.wikipedia.org/wiki/ISO_8601#Dates
  # YYYY-MM-DD
  # YYYY = Four digits
  # MM = a zero-padded number from 01 to 12
  # DD = a zero padded number from 00 to 31
  return(
    grepl("^\\d{4}-([0]\\d|1[0-2])-([0-2]\\d|3[01])$", x)
  )
}

#' Check LSOA string format
#'
#' @description
#'
#' An LSOA is a [Lower Layer Super Output Area](https://webarchive.nationalarchives.gov.uk/ukgwa/20160106001702/https://www.ons.gov.uk/ons/guide-method/geography/beginner-s-guide/census/super-output-areas--soas-/index.html) geographical area clustering code.
#'
#' See:
#' - Wikipedia [GSS coding system](https://en.wikipedia.org/wiki/GSS_coding_system)
#' - UK ONS Geography [Lower Layer Super Output Areas (December 2011) Names and Codes in England and Wales](https://geoportal.statistics.gov.uk/datasets/ons::lower-layer-super-output-areas-december-2011-names-and-codes-in-england-and-wales-1/explore)
#' - UK Data Service [Lower Super Output Areas and Data Zones borders](https://statistics.ukdataservice.ac.uk/dataset/2011-census-geography-boundaries-lower-layer-super-output-areas-and-data-zones/resource/d65a0201-7240-4d18-8ab2-9d8c1ad830d6) contains all possible LSOA values.
#'
#' @param x character. String to validate.
#'
#' @return
#' logical. Returns TRUE if the string is a valid LSOA code.
#' @export
#'
#' @examples
#' lsoa_format("E01014417") # TRUE
#' lsoa_format("E101447") # FALSE
lsoa_format <- function(x) {
  # Length 9 alphanumeric (upper-case)
  return(grepl("^[A-Z0-9]{9}$", x))
}


#' Save results summary to a CSV file
#'
#' @description
#' See [the example](https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html#11_A_quick_example)
#' in the The Data Validation Cookbook.
#'
#' @param results The output of validate::confront
#' @param path character, file path of output CSV file.
#'
#' @export
#'
serialise_validation <- function(results, path = NA) {
  # Get output file path
  if (is.na(path)) {
    path <- tempfile(fileext = ".csv", tmpdir = temp_dir())
  } else {
    path <- normalizePath(path, mustWork = FALSE)
  }

  # Get validation summary
  results_summary <- validate::summary(results)
  # Sort by name
  results_summary <- results_summary[order(results_summary$name),]

  # Save to disk
  write.csv(results_summary, file = path)
  cli::cli_inform("Wrote '{path}'")
}

#' Visualise results
#'
#' @description
#' See the [Data Validation Cookbook](https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html#11_A_quick_example)
#'
#' @param results The output of validate::confront
#' @param path character, file path of output CSV file.
#' @param ... Arguments for plot(...)
#'
#' @export
#'
serialise_validation_plot <- function(results, path = NA, ...) {
  # Get output file path
  if (is.na(path)) {
    # Create temporary file with a random file name
    path <- tempfile(fileext = ".pdf", tmpdir = temp_dir())
  } else {
    path <- normalizePath(path, mustWork = FALSE)
  }

  pdf(path)
  plot(results, ...)
  dev.off()
  cli::cli_inform("Wrote '{path}'")
}
