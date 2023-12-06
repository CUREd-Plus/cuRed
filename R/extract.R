library(fs)
library(logger)
library(readr)
library(stringr)


#' @title Extract data from SQL queries
#'
#' @description
#' This function extracts data from SQL queries and saves it to Apache Parquet format.
#'
#' An extract is defined by the following files:
#'
#' - Each input SQL file represents an output data table e.g. `apc.sql`
#' - There must be a `README.txt` file in the extract.
#'
#' For example:
#'
#' ```
#' └───my_extract
#'     ├──README.txt
#'     ├──apc.sql
#'     └──op.sql
#' ```
#'
#' This function will read data from the clean data directory using the supplied SQL queries and write output
#' data tables to the extract working directory.
#'
#' @param working_dir The path of the directory containing the extract definition.
#' @param clean_dir The path of the directory containing the clean data to be used in the queries.
#' @returns Path of the directory that contains the data extract.
#' @export
extract <- function(working_dir, clean_dir, sep = .Platform$file.sep) {

  audit()

  # Check directory paths
  working_dir = normalizePath(working_dir, mustWork = TRUE)
  clean_dir = normalizePath(clean_dir, mustWork = TRUE)

  logger::log_info("Running data extract '{working_dir}'")
  logger::log_info("Reading clean data from '{clean_dir}'")

  # Iterate over queries
  # Each input SQL file represents an output data table
  for (path in fs::dir_ls(working_dir, glob = "*.sql")) {
    logger::log_info("Loading '{path}'...")
    query_template <- readr::read_file(path)

    # Insert read_parquet() functions
    # Replace /*hes_apc.apc*/ with read_parquet('/clean/data/hes_apc/apc.parquet')
    query_select <- stringr::str_replace_all(
      string = query_template,
      pattern = stringr::regex("/\\*(.+)\\.(.+)\\*/", ignore_case = TRUE),
      replacement = "read_parquet('{clean_dir}{sep}\\1{sep}\\2.parquet')"
    )

    # Insert variable values
    query_select <- stringr::str_glue(query_select)

    # Output table identifier
    # Get the path stub only, e.g. "/path/file.txt" -> "file"
    table_id <- tools::file_path_sans_ext(basename(path))

    output_path <- fs::path(working_dir, paste(table_id, ".parquet", sep = ""))

    query <- stringr::str_glue("
    COPY (
      {query_select}
    ) TO '{output_path}'
    ")

    # Save the query, but don't share with the users.
    logger::log_info(query)

    run_query(query)

    logger::log_success("Wrote '{output_path}'")
  }

  # Check readme exists
  readme_path <- fs::path(working_dir, "README.txt")
  if (!fs::file_exists(readme_path)) {
    logger::log_error("File not found: {readme_path}")
    stop("README.txt missing")
  }

  return(working_dir)
}
