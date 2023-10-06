library(cli)

#' Run workflow
#'
#' @description
#' `main` executes the entire data pipeline for all data sets.
#'
#' @details
#' TODO
#'
#' @export
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

  # Load the configuration file
  data_sets_path <- system.file('extdata', 'data-sets.json', package='cuRed')
  data_sets = as.data.frame(jsonlite::fromJSON())
  
  # Iterate over data sets
  for (i in seq_len(nrow(data_sets))) {
    data_set_id <- data_sets$id[i]
    cli::cli_alert_info("Running {data_set_id}")
    # Run each workflow
    run_workflow(data_set_id, root_directory)
  }
}
