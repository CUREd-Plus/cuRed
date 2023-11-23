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
#' The resultant binary data files will be written to `output_dir`.
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
#' @param input_dir character. Path. The directory that contains the raw data files.
#' @param output_dir Character. Path of the directory in which to write the output binary data files.
#' @param metadata List. Dictionary containing the column definitions.
#' @param data_set_id character. Data set identifier e.g. "apc", "op"
#'
#' @returns List of paths of the new output files.
#' @export
csv_to_binary <- function(input_dir, output_dir, metadata, data_set_id) {

  # Define the absolute paths
  input_dir <- normalizePath(input_dir, mustWork = TRUE)
  output_dir <- normalizePath(output_dir, mustWork = FALSE)
  output_paths <- list()

  # Load column order and default data types
  csv_metadata_path <- extdata_path(stringr::str_glue("metadata/raw/{data_set_id}.json"))
  csv_metadata <- jsonlite::fromJSON(csv_metadata_path)
  cli::cli_alert_info("Loaded '{csv_metadata_path}'")

  # Iterate over tables (CSV files within this data set)
  for (i in seq_len(length(csv_metadata$tables))) {
    csv_table <- csv_metadata$tables[i]
    table_id <- csv_table$id
    data_types <- csv_table$tableSchema$columns[[1]]

    # Convert to SQL data types
    data_types = dplyr::mutate(data_types, datatype = xml_schema_to_sql_data_type(datatype))
    
    # TODO update data types based on TOS or data dictionary
    
    # Convert file format
    # Load the CSV file and save to Apache Parquet format.
    
    # Define where the data will be read from
    input_glob <- file.path(input_dir, csv_table$url)
    output_path <- file.path(output_dir, table_id)
    
    # Build the SQL query that will be used to perform the conversion
    data_types_dict <- dataframe_to_dictionary(data_types, "name", "datatype")
    data_types_struct <- dictionary_to_struct(data_types_dict)
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
    cli::cli_alert_success("Wrote '{output_path}'")
  }

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
