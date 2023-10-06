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
#' @param data_sets_path String. Path. The path of the configuration file. Defaults to the one included in the library.
#'
main <- function(data_sets_path = NA) {
  # Set the file path of the configuration file
  if (is.na(data_sets_path)) {
    data_sets_path <- system.file("extdata", "data_sets.json", package = "cuRed", mustWork = TRUE)
  }

  data_sets_path <- normalizePath(file.path(data_sets_path), mustWork = TRUE)

  # Load the configuration file
  # This is a list of objects, each represents a data set
  data_sets <- as.data.frame(jsonlite::fromJSON(data_sets_path))
  data_sets <- as.data.frame(jsonlite::fromJSON())

  # Iterate over data sets
  for (i in seq_len(nrow(data_sets))) {
    data_set_id <- as.character(data_sets$id[i])
    raw_data_dir <- normalizePath(file.path(data_sets$raw_data_dir[i]), mustWork = TRUE)
    staging_dir <- normalizePath(file.path(data_sets$staging_dir[i]), mustWork = FALSE)
    metadata_path <- normalizePath(file.path(data_sets$metadata_path[i]), mustWork = TRUE)

    cli::cli_alert_info("Running workflow for data set '{data_set_id}'")
    cli::cli_alert_info("Raw data directory '{raw_data_dir}'")

    # Run the workflow for this data set
    run_workflow(
      data_set_id = data_set_id,
      raw_data_dir = raw_data_dir,
      staging_dir = staging_dir
    )
  }
}
