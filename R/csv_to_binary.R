library(cli)
library(DBI)
library(duckdb)
library(stringr)
library(utils)

#' Use Duck DB to perform file format conversion.
#'
#' A JSON file must be specified that contains an object where the keys are the headers of the input CSV files in order
#' and the values are the SQL data types (default to "VARCHAR"). The location of this file is `data_types_path`.
#'
#' See:
#'
#' - [DuckDB R API](https://duckdb.org/docs/api/r)
#' - [DBI documentation](https://dbi.r-dbi.org/)
#'
#' @export
#'
#' @param raw_data_dir character Path. The directory that contains the raw data files.
#' @param output_data_dir character Path. The directory the output data file(s) should be written to.
#' @param metadata List. Dictionary containing the column definitions.
#' @param data_set_id character Data set identifier e.g. "apc", "op"
#' @param output_filename character,file name of the binary data file e.g. "apc_binary.parquet"
#'
#' @returns String. Path. The path of the output data file.
csv_to_binary <- function(raw_data_dir, output_data_dir, metadata, data_set_id, output_filename=NA) {

  if (is.na(output_filename)) {
    output_filename = stringr::str_glue("{data_set_id}_binary.parquet")
  }

  raw_data_dir <- normalizePath(raw_data_dir, mustWork = TRUE)
  output_data_dir <- normalizePath(output_data_dir, mustWork = FALSE)

  # Define the absolute paths
  input_glob <- file.path(raw_data_dir, "*.csv")
  output_path <- file.path(output_data_dir, output_filename)
  sql_query_file_path <- paste(output_path, ".sql", sep = "")
  data_types_path <- extdata_path(stringr::str_glue("sql_data_types/{data_set_id}.json"))

  # Load column order and default data types
  data_types <- jsonlite::fromJSON(data_types_path)

  # Append patient ID fields
  patient_id_data_types_path <- extdata_path("sql_data_types/patient_id_bridge.json")
  patient_id_data_types <- jsonlite::fromJSON(patient_id_data_types_path)
  data_types = utils::modifyList(data_types, patient_id_data_types)

  # Update data types based on TOS spreadsheet
  # I'm not using utils::modifyList because we don't want to include all the fields in the TOS,
  # but only use the columns we've specified.
  tos_data_types <- get_data_types(metadata)
  for (key in data_types) {
    data_types[key] <- tos_data_types[key]
  }

  # Convert file format
  # Load the CSV file and save to Apache Parquet format.

  # Build SQL query
  data_types_struct <- convert_json_to_struct(jsonlite::toJSON(data_types))
  query_path <- normalizePath(system.file("extdata", "queries/csv_to_binary.sql", package = "cuRed"), mustWork = TRUE)
  query_template <- readr::read_file(query_path)
  query <- stringr::str_glue(query_template)

  # Ensure output directory exists
  dir.create(output_data_dir, recursive = TRUE, showWarnings = FALSE)

  # Write SQL query to text file
  readr::write_file(query, sql_query_file_path)
  cli::cli_alert_info("Wrote '{sql_query_file_path}'")

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
#' @returns Dictionary. Map of field names to data types.
#'
get_data_types <- function(metadata) {
  # Initialise empty dictionary
  field_names <- list()

  # Iterate over list items
  for (i in seq_len(nrow(metadata))) {
    field_name <- as.character(metadata$Field[i])
    tos_format <- as.character(metadata$Format[i])

    # Build dictionary
    field_names[field_name] <- format_to_data_type(tos_format)
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

#' Convert TOS format to an SQL data type
#'
#' See: NHS Digital "Constructing submission files" for the data formats from
#' the NHS Data Model and Dictionary.
#'
#' [DuckDB data types](https://duckdb.org/docs/sql/data_types/overview.html)
#'
#' @export
#'
#' @param format_str String. TOS format string e.g. "Date(YYYY-MM-DD)" or "Number"
#'
#' @returns String. SQL data type.
#'
format_to_data_type <- function(format_str) {
  format_str <- as.character(format_str)

  if (is.na(format_str)) {
    stop("Format string is null.")
  }

  # Map TOS format to SQL data type
  # https://duckdb.org/docs/sql/data_types/overview.html

  # Integer
  if (format_str == "Number") {
    # unsigned four-byte integer
    data_type <- "UBIGINT"
  } else if (startsWith(format_str, "String")) {
    # TODO set maximum string length
    # https://duckdb.org/docs/sql/data_types/text
    data_type <- "VARCHAR"
  } else if (format_str == "Date(YYYY-MM-DD)") {
    data_type <- "DATE"
  } else if (format_str == "Time(HH24:MI:ss)") {
    data_type <- "TIME"
  } else if (format_str == "Decimal") {
    data_type <- "DOUBLE"
    # The HES APC TOS field SOCIAL_AND_PERSONAL_CIRCUMSTANCE has format "?" because it's a
    # SNOMED CT Expression, which is of alphanumeric "an" type (a structured object).
    # https://www.datadictionary.nhs.uk/data_elements/snomed_ct_expression.html
  } else if (format_str == "?") {
    data_type <- "VARCHAR"
  } else {
    cli::cli_alert_danger("Unknown field format '{format_str}'")
    stop("Unknown field format")
  }

  return(data_type)
}
