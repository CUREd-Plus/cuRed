library(cli)

#' Generate sample data from NHS Artificial data pilot
#'
#' NHS Digital [Artificial data pilot](https://digital.nhs.uk/services/artificial-data)
#'
#' @export
#'
#' @param data_urls character, set of URIs of CSV data files to download
#' @param number_of_rows integer, How many rows to export
#'
get_sample_data <- function(data_urls, number_of_rows = 100) {

  output_paths <- list()

  for (url in data_urls) {

    path <- get_sample_data_file(
      url = url,
      number_of_rows = number_of_rows
    )

    append(output_paths, path)
  }

  return(output_paths)
}

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
get_sample_data_file <- function(url, number_of_rows, output_path = NA) {

  # Create a temporary file
  if (is.na(output_path)) {
    output_path <-  tempfile(tmpdir = temp_dir(), fileext = ".csv")
  }

  # Create working directory
  tmpdir <- temp_dir()

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
  files = file.path(tmpdir, files)
  lines <- readr::read_lines(files, n_max = number_of_rows)
  readr::write_lines(lines, file = output_path)

  # Inform user what happened
  cli::cli_alert_info("Wrote {number_of_rows} rows to '{output_path}'")

  return(output_path)
}
