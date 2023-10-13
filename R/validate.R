library(dataverifyr)

#' Validate input raw data
#'
#' This uses the [Data vertifyer package](https://davzim.github.io/dataverifyr/).
#'
#' @param data_path String. Source data file path.
#' @param rules_path String. Data validation rules file path.
#'
#' @export
validate <- function(data_path, rules_path) {
  # Get input file paths
  data_path <- normalizePath(file.path(data_path), mustWork = TRUE)
  rules_path <- normalizePath(file.path(rules_path), mustWork = TRUE)

  # Load rule set from a YAML file
  # https://davzim.github.io/dataverifyr/reference/write_rules.html
  rules <- dataverifyr::read_rules(rules_path)
  results <- verify(file_path = data_path, rules = rules)

  return(results)
}

#' Verify the schema of a data file using a rule set.
#'
#' Uses the [dataverifyr package](https://davzim.github.io/dataverifyr/index.html).
#'
#' @param file_path String. Input data file path.
#' @param rules String. YAML file path, data validation rules.
#'
#' @returns Data validation results, one row per rule.
#'
#' @export
#'
verify <- function(file_path, rules) {
  # Check input file exists
  file_path <- normalizePath(file.path(file_path), mustWork = TRUE)

  # Load data
  data <- read_parquet(file_path)

  # Run the data validation checks
  # https://davzim.github.io/dataverifyr/reference/check_data.html
  results <- dataverifyr::check_data(
    x = data,
    rules = rules,
    fail_on_warn = FALSE,
    fail_on_error = FALSE
  )

  return(results)
}
