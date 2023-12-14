library(logger)
library(utils)

#' Download a sample data file
#'
#' @param url character URI of CSV file to download
#' @param number_of_rows integer truncate the output data to this number of lines
#' @param output_path character path, export the output data to the file
#'
#' @export
#'
#' @returns Character path of output CSV file
#'
get_sample_data <- function(url, number_of_rows = NA, output_path = NA) {

  # Create a temporary file
  if (is.na(output_path)) {
    output_path <-  tempfile(tmpdir = temp_dir(), fileext = ".csv")
  }

  # Create working directory
  tmpdir <- temp_dir()
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)

  filename <- basename(url)

  # Download sample data (ZIP archive of CSVs)
  path <- file.path(tmpdir, filename)
  utils::download.file(url, method = "auto", destfile = path, mode = "wb", quiet = TRUE)
  logger::log_info("Downloaded '{path}'")

  # Show archive contents
  zipped_files <- utils::unzip(path, list = TRUE)$Name
  # Just get CSV files
  zipped_files = zipped_files[grepl("\\.csv$", zipped_files)]

  # Get the first CSV file only
  files <- zipped_files[1]
  utils::unzip(path, files = files, exdir = tmpdir, setTimes = TRUE)

  # Truncate CSV
  if (!is.na(number_of_rows)) {
    number_of_rows = as.integer(number_of_rows)
    number_of_lines <- number_of_rows + 1 # including the CSV header
    files = file.path(tmpdir, files)
    lines <- readr::read_lines(files, n_max = number_of_lines)
    readr::write_lines(lines, file = output_path)
  }

  # Inform user what happened
  logger::log_success("Wrote {number_of_rows} rows to '{output_path}'")

  return(output_path)
}

#' Append generated dummy data in CSV format.
#'
#' Append fake patient identifiers to the synthetic data.
#'
#' @param input_path character path of input CSV data file (or files, e.g. "*.csv")
#' @param output_path character path of output CSV data file
#'
#' @returns character path of output data file
#'
#' @export
#'
append_mock_ids <- function(input_path, output_path) {

  # Build the SQL query using a template
  query_template_path <- extdata_path("queries/append_mock_ids.sql")
  query_template <- readr::read_file(query_template_path)
  query <- stringr::str_glue(query_template)
  query_path <- paste(output_path, ".sql", sep = "")
  readr::write_file(x = query, file = query_path)
  logger::log_info("Wrote '{query_path}'")

  # Run query to generate data
  run_query(query)
  logger::log_success("Wrote '{output_path}'")

  return(output_path)
}


#' Generate synthetic demographics data and write it to a specified file.
#'
#' @description
#' This function generates synthetic demographics data by executing a SQL query
#' template read from a file. The generated data is then written to the specified
#' output file path.
#'
#' @param output_path The path to the file where the generated data will be written.
#' @param n_rows The number of rows to generate in the synthetic demographics data (default is 1000).
#' @export
#' @returns Path of the generated data file.
generate_demographics <- function(output_path, n_rows = 1000) {
  return(generate_data(output_path = output_path, n_rows = n_rows, data_set_id = "pd"))
}


#' Generate synthetic patient identifier data and write it to a specified file.
#'
#' @description
#' This function generates synthetic patient ID data by executing a SQL query
#' template read from a file. The generated data is then written to the specified
#' output file path.
#'
#' @param output_path The path to the file where the generated data will be written.
#' @param n_rows The number of rows to generate. Default: 1000
#' @export
#' @returns Path of the generated data file.
generate_patients <- function(output_path, n_rows = 1000) {
  return(generate_data(output_path = output_path, n_rows = n_rows, data_set_id = "patient"))
}


#' Generate synthetic data and write it to a specified file.
#'
#' @description
#' This function generates synthetic data by executing a SQL query
#' template read from a file. The generated data is then written to the specified
#' output file path.
#'
#' @param output_path The path to the file where the generated data will be written.
#' @param n_rows The number of rows to generate. Default: 1000
#' @param query_template_path The path of the SQL query file.
#' @param data_set_id Data set identifier e.g. "patient", "ecds"
#' @export
#' @returns Path of the generated data file.
generate_data <- function(output_path, n_rows = 1000, query_template_path = NA, data_set_id = NA) {
  if (is.na(query_template_path)) {
    query_template_path <- extdata_path("queries/synthetic/{data_set_id}.sql")
  }
  query_template <- readr::read_file(query_template_path)
  query <- stringr::str_glue(query_template)
  run_query(query)
  logger::log_success("Wrote '{output_path}'")
  return(output_path)
}
