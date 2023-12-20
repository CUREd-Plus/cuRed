library(logger)
library(coro)
library(dplyr)
library(fs)
library(stringr)
library(utils)

#' Convert CSV data into binary format
#'
#' @description
#' The code uses DuckDB to perform file format conversion.
#'
#' By default, this function will read all the CSV files in the `input_dir` and convert them to
#' [Apache Parquet](https://parquet.apache.org/) format.
#'
#' The resultant binary data files will be written to `output_dir`.
#'
#' @param input_dir character. Path. The directory that contains the raw data files.
#' @param output_dir Character. Path of the directory in which to write the output binary data files.
#' @param data_set_id character. Data set identifier e.g. "apc", "op"
#'
#' @returns List of paths of the new output files.
#' @export
csv_to_binary <- function(input_dir, output_dir, data_set_id) {

  # Define the absolute paths
  input_dir <- normalizePath(input_dir, mustWork = TRUE)
  output_dir <- normalizePath(output_dir, mustWork = FALSE)
  output_paths <- list()

  # Load data set metadata
  csv_metadata_path <- extdata_path(stringr::str_glue("metadata/raw/{data_set_id}.json"))
  csv_metadata <- read.csvw(csv_metadata_path)

  # Iterate over tables (CSV files within this data set)
  coro::loop(for (csv_table in csvw.tables(csv_metadata)) {
    # Get table identifier
    table_id <- csv_table$id
    if (is.na(table_id)) {
      stop("table_id is missing")
    }
    logger::log_info("Data set '{data_set_id}', table id '{table_id}'")
    columns <- csvw.columns(csv_table)

    # Convert file format
    # Load the CSV file and save to Apache Parquet format.

    # Get data types
    schema <- csvw_to_arrow_schema(columns)

    # Define input CSV files
    input_glob <- file.path(input_dir, csv_table$url)
    sources <- fs::dir_ls(input_dir, glob = input_glob)

    # Convert CSV dialect to DuckDB read_csv arguments
    delim <- csv_metadata$metadata$delimeter
    header <- csv_metadata$metadata$header
    skip <- 0
    if (header) { skip = 1 }

    # Read CSV files
    data_set <- arrow::open_dataset(sources = sources, schema = schema, format = "csv", delim = delim, skip = skip)

    # Convert to Apache Parquet format
    arrow::write_dataset(data_set, path = output_dir, format = "parquet")

    # Append to
    output_paths = append(output_path, fs::dir_ls(output_dir, glob = "*.parquet"))
  })

  return(output_paths)
}
