library(cli)

#' Run workflow
#'
#' @description
#' `main` executes the entire data pipeline for all data sets.
#'
#' @details
#' TODO
#'
#' @param root_directory String. Path. The directory that contains all the working directories.
#'
main <- function(root_directory) {
  root_directory <- file.path(root_directory)

  # Check whether the data directory exists
  if (file.exists(root_directory)) {
    cli::cli_alert_info("Root directory '{root_directory}'")
  } else {
    cli::cli_alert_warning("Directory doesn't exist '{root_directory}'")
    stop("Data directory not found")
  }

  # A list of the unique identifier of each of the data sets to work with.
  data_set_ids <- c("apc", "ae", "op")

  # Iterate over data sets
  for (data_set_id in data_set_ids) {
    cli::cli_alert_info("Running {data_set_id}")
    # Run each workflow
    run_workflow(data_set_id, root_directory)
  }
}
