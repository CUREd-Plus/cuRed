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

  # Save summary to a CSV file
  # results_summary_path <- file.path(output_dir, 'results_summary.csv')
  # write.csv(summary(results), file = results_summary_path)
  # cli::cli_inform("Wrote '{results_summary_path}'")

  # Visualise results
  # https://davzim.github.io/dataverifyr/reference/plot_res.html
  # plot_path <- file.path(output_dir, "results.pdf")
  # pdf(plot_path)
  # plot(
  #   results,
  #   main = paste(data_path, rules_path, sep = "\n"),
  # )
  # dev.off()
  # cli::cli_inform("Wrote '{plot_path}'")

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
  # MM = a zero-padded number up to 1-12
  # DD = a zero padded number up to 31
  return(
    grepl("^\\d{4}-([0]\\d|1[0-2])-([0-2]\\d|3[01])$", x)
  )
}
