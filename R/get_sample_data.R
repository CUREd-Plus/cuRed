library(cli)

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
get_sample_data <- function(url, number_of_rows, output_path = NA) {

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
  download.file(url, method = "auto", destfile = path, mode = "wb", quiet = TRUE)
  cli::cli_alert_info("Downloaded '{path}'")

  # Show archive contents
  zipped_files <- unzip(path, list = TRUE)$Name
  # Just get CSV files
  zipped_files = zipped_files[grepl("\\.csv$", zipped_files)]

  # Get the first CSV file only
  files <- zipped_files[1]
  unzip(path, files = files, exdir = tmpdir, setTimes = TRUE)

  # Truncate CSV
  number_of_lines <- number_of_rows + 1 # including the CSV header
  files = file.path(tmpdir, files)
  lines <- readr::read_lines(files, n_max = number_of_lines)
  readr::write_lines(lines, file = output_path)

  # Inform user what happened
  cli::cli_alert_info("Wrote {number_of_rows} rows to '{output_path}'")

  return(output_path)
}

#' Generate dummy data
#'
#' Append fake patient identifiers to the synthetic data.
#'
#' @param input_path character path of input data file (or files, e.g. "*.csv")
#' @param output_path character path of output data file
#' @param format character output file format
#'
#' @returns character path of output data file
#'
#' @export
#'
append_mock_ids <- function(input_path, output_path = NA, format="CSV", read_func = "read_csv_auto") {

  # Guess sensible default
  if (is.na(output_path)) {
    # File extension e.g. ".csv"
    fileext <- paste(".", casefold(format), sep = "")
    output_path <- tempfile(fileext = fileext, tmpdir = temp_dir())
  } else {
    output_path <- normalizePath(output_path, mustWork = FALSE)
  }

  if (read_func != "read_csv_auto") {
    read_func = casefold(stringr::str_glue("read_{format}"))
  }

  # Run query to generate data
  query <- stringr::str_glue("
  COPY (
    SELECT
      -- Generate mock patient identifiers
      uuid() AS token_person_id,
      uuid() AS yas_id,
      uuid() AS cured_id,
      uuid() AS study_id,
      -- Append input data set
      input_data.*
    FROM {read_func}('{input_path}') AS input_data
  )
  TO '{output_path}'
  WITH (FORMAT '{format}');
  ")
  query_path <- file.path(dirname(output_path), "mock.sql")
  readr::write_file(x = query, file = query_path)
  run_query(query)
  cli::cli_alert_info("Wrote '{output_path}'")

  return(output_path)
}
