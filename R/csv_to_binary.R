library(logger)
library(coro)
library(dplyr)
library(stringr)
library(utils)

#' Convert CSV data into binary format
#'
#' @description
#' The code uses DuckDB to perform file format conversion. This function will build an SQL script that is executed
#' using DuckDB.
#'
#' By default, this function will read all the CSV files in the `input_dir` and convert them to
#' [Apache Parquet](https://parquet.apache.org/) format.
#'
#' The resultant binary data files will be written to `output_dir`.
#'
#' The structure of the CSV file is specified by a [CSVW](https://csvw.org/) document specified by `csv_metadata_path`.
#' This should include a [CSV dialect](https://specs.frictionlessdata.io/csv-dialect/) specification if a non-standard
#' CSV format is used.
#'
#' See:
#'
#' - [DuckDB R API](https://duckdb.org/docs/api/r)
#' - [DBI documentation](https://dbi.r-dbi.org/) and [configuration](https://duckdb.org/docs/sql/configuration.html)
#' - DuckDB [CSV Import](https://duckdb.org/docs/data/csv/overview.html)
#' - [CSV on the Web](https://csvw.org/)
#'
#' @param input_dir character. Path. The directory that contains the raw data files.
#' @param output_dir Character. Path of the directory in which to write the output binary data files.
#' @param data_set_id character. Data set identifier e.g. "apc", "op"
#' @param csv_metadata_path The path of the CSVW metadata file. Default: inst/extdata/metadata/raw//{data_set_id}.json
#' @param delim The character sequence which should separate CSV fields. Default: ","
#' @param header Logical. Indicates whether the file includes a header row. Default: TRUE
#' @param temp_directory Set the directory to which to write temp files. DuckDB configuration option.
#' @param query_path Path of the SQL query that defines the data operation.
#'
#' @returns List of paths of the new output files.
#' @export
csv_to_binary <- function(input_dir, output_dir, data_set_id, csv_metadata_path = NA, delim = ',', header = TRUE, temp_directory = NA, query_path = NA) {

  # Define the absolute paths
  input_dir <- normalizePath(input_dir, mustWork = TRUE)
  output_dir <- normalizePath(output_dir, mustWork = FALSE)
  output_paths <- list()

  if (is.na(temp_directory)) {
    temp_directory = temp_dir()
  }

  # Load data set metadata
  if (is.na(csv_metadata_path)) {
    csv_metadata_path <- extdata_path(stringr::str_glue("metadata/raw/{data_set_id}.json"))
  }
  csv_metadata <- read.csvw(csv_metadata_path)

  # Convert CSV dialect to DuckDB read_csv arguments
  delim = csv_metadata$metadata$delimeter
  header = csv_metadata$metadata$header

  # Iterate over tables (CSV files within this data set)
  # https://w3c.github.io/csvw/syntax/#tables
  coro::loop(for (csv_table in csvw.tables(csv_metadata)) {
    # Get table identifier
    table_id <- csv_table$id
    if (is.na(table_id)) {
      stop("table_id is missing")
    }
    logger::log_info("Data set '{data_set_id}', table id '{table_id}'")
    columns <- csvw.columns(csv_table)

    # Convert to SQL data types
    data_types <- data.frame(columns[, c("name", "datatype")])
    data_types <- dplyr::mutate(data_types, datatype = xml_schema_to_sql_data_type(datatype))

    # TODO update data types based on TOS or data dictionary

    # Convert file format
    # Load the CSV file and save to Apache Parquet format.

    # Define where the data will be read from
    input_glob <- file.path(input_dir, csv_table$url)

    # Iterate over input files
    for (input_path in fs::dir_ls(glob = input_glob)) {
      logger::log_info(input_path)

      # ...and written to
      output_filename <- paste(basename(input_path), ".parquet", sep = "")
      output_path <- file.path(output_dir, output_filename)

      # Build the SQL query that will be used to perform the conversion
      data_types_dict <- dataframe_to_dictionary(data_types, "name", "datatype")
      data_types_struct <- dictionary_to_struct(data_types_dict)
      if (is.na(query_path)) {
        query_path <- extdata_path("queries/csv_to_binary.sql")
      }
      query_template <- readr::read_file(query_path)
      # Put variable values into the template
      query <- stringr::str_glue(query_template)

      # Ensure output directory exists
      dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

      # Write SQL query to text file
      sql_query_file_path <- paste(output_path, ".sql", sep = "")
      readr::write_file(query, sql_query_file_path)
      logger::log_info("Wrote '{sql_query_file_path}'")

      # Execute the query
      logger::log_info("Reading input data from '{input_glob}'...")
      run_query(query)
      logger::log_success("Wrote '{output_path}'")

      # Append to
      output_paths = append(output_paths, output_path)
    }
  })

  return(output_paths)
}

#' Get data types
#'
#' @description
#' Get the data type for each field from the metadata document.
#'
#' @export
#'
#' @param metadata List of field objects.
#' @param data_set_id Data set identifier
#' @returns Dictionary. Map of field names -> data types.
#'
get_data_types <- function(metadata, data_set_id) {
  # Initialise empty dictionary
  field_names <- list()

  # Iterate over list items
  for (i in seq_len(nrow(metadata))) {
    field_name <- as.character(metadata$Field[i])
    tos_format <- as.character(metadata$Format[i])

    # Build dictionary
    # Decide what data type standard to use, based on the data set.
    if (data_set_id %in% c("apc", "op", "ae")) {
      sql_data_type <- format_to_data_type(tos_format)
    } else if (startsWith(data_set_id, "yas")) {
      sql_data_type <- yas_type_to_data_type(tos_format)
    } else {
      logger::log_error("Unknown data type for '{data_set_id}' data set")
      stop("Unknown data type format")
    }
    field_names[field_name] <- sql_data_type
  }

  return(field_names)
}
