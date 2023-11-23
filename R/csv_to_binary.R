library(cli)
library(dplyr)
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
#' The resultant binary data file will be written to `output_path`.
#'
#' A [JSON](https://www.json.org/json-en.html) file must be specified that contains an object where the keys are the
#' headers of the input CSV files in order and the values are the SQL data types (default to `"VARCHAR"`). The location
#' of this file is stored in the `data_types_path` variable and defaults to
#' `inst/extdata/sql_data_types/{data_set_id}.json`.
#'
#' See:
#'
#' - [DuckDB R API](https://duckdb.org/docs/api/r)
#' - [DBI documentation](https://dbi.r-dbi.org/)
#' - DuckDB [CSV Import](https://duckdb.org/docs/data/csv/overview.html)
#'
#' @export
#'
#' @param input_dir character. Path. The directory that contains the raw data files.
#' @param output_path character. Path of the output binary data file.
#' @param metadata List. Dictionary containing the column definitions.
#' @param data_set_id character. Data set identifier e.g. "apc", "op"
#' @param glob character. *(Optional)* Input file pattern e.g. "*.csv" or "*_raw.csv"
#'
#' @returns String. Path. The path of the output data file.
csv_to_binary <- function(input_dir, output_path, metadata, data_set_id, glob="*.csv") {

  # Define the absolute paths
  input_dir <- normalizePath(input_dir, mustWork = TRUE)
  input_glob <- file.path(input_dir, glob)
  output_path <- normalizePath(output_path, mustWork = FALSE)

  # Load column order and default data types
  csv_metadata_path <- extdata_path(stringr::str_glue("metadata/raw/{data_set_id}.json"))
  csv_metadata <- jsonlite::fromJSON(csv_metadata_path)
  cli::cli_alert_info("Loaded '{csv_metadata_path}'")

  # Iterate over tables
  for (i in seq_len(length(csv_metadata$tables))) {
    csv_table <- csv_metadata$tables[i]
    data_types <- csv_table$tableSchema$columns[[1]]

    # Convert to SQL data types
    data_types = dplyr::mutate(data_types, datatype = xml_schema_to_sql_data_type(datatype))
  }

  # Get the SQL data types for the supplied metadata (TOS, data dictionary, etc.)
  if (data_set_id %in% c("apc", "op", "ae")) {
    metadata = dplyr::mutate(metadata, Format = format_to_data_type(Format))
  } else if (startsWith(data_set_id, "yas")) {
    metadata = dplyr::mutate(metadata, type = yas_type_to_data_type(type))
  } else {
    cli::cli_alert_danger("Unknown data type for '{data_set_id}' data set")
    stop("Unknown data type format")
  }

  # Convert file format
  # Load the CSV file and save to Apache Parquet format.

  # Build SQL query
  data_types_struct <- convert_json_to_struct(jsonlite::toJSON(data_types))
  query_path <- extdata_path("queries/csv_to_binary.sql")
  query_template <- readr::read_file(query_path)
  query <- stringr::str_glue(query_template)

  # Ensure output directory exists
  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

  # Write SQL query to text file
  sql_query_file_path <- paste(output_path, ".sql", sep = "")
  readr::write_file(query, sql_query_file_path)
  cli::cli_alert_info("Wrote '{sql_query_file_path}'")

  # Execute the query
  cli::cli_alert_info("Reading input data from '{input_glob}'...")
  run_query(query)
  cli::cli_alert_info("Wrote '{output_path}'")

  return(output_path)
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
      cli::cli_alert_danger("Unknown data type for '{data_set_id}' data set")
      stop("Unknown data type format")
    }
    field_names[field_name] <- sql_data_type
  }

  return(field_names)
}

#' Convert JSON object to an SQL struct
#'
#' @export
#'
#' @param data String. JSON data. The data structure is assumed to be an
#' object (dictionary).
convert_json_to_struct <- function(data) {
  object <- jsonlite::fromJSON(data)

  # Convert from JSON to DuckDB struct for use in  SQL queries
  # https://duckdb.org/docs/sql/data_types/struct.html

  items <- vector()

  # Iterate over the key-value pairs of the dictionary
  for (key in names(object)) {
    value <- object[[key]]

    item <- stringr::str_glue("'{key}': '{value}'")
    items <- c(items, item)
  }

  items_char <- stringr::str_flatten_comma(items)
  struct <- stringr::str_glue("{{{items_char}}}", collapse = "", sep = "")
  return(struct)
}
