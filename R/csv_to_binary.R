library(DBI)
library(duckdb)
library(cli)

#' Use Duck DB to perform file format conversion.
#'
#' See:
#'
#' - [DuckDB R API](https://duckdb.org/docs/archive/0.8.1/api/r)
#' - [DBI documentation](https://dbi.r-dbi.org/)
#'
#' @param raw_data_dir String. Path. The directory that contains the raw data files.
#' @param output_data_dir String. Path. The directory the output data file(s) should be written to.
#' @param metadata List. Dictionary containing the column definitions.
#'
#' @returns String. Path. The path of the output data file.
#'
#' @export
csv_to_binary <- function(raw_data_dir, output_data_dir, metadata) {
  cli::cli_alert_info("Converting from CSV to parquet...")

  # Define the absolute paths
  input_glob <- normalizePath(file.path(raw_data_dir, "*.csv"), mustWork = FALSE)
  metadata_path <- normalizePath(file.path(raw_data_dir, "metadata.json"), mustWork = FALSE)
  sql_query_file_path <- normalizePath(file.path(output_data_dir, "query.sql"), mustWork = FALSE)
  output_path <- normalizePath(file.path(output_data_dir, "data.parquet"), mustWork = FALSE)

  # Get data types
  cli::cli_alert_info("Loading '{metadata_path}'")
  metadata <- jsonlite::fromJSON(metadata_path)
  data_types <- get_data_types(metadata)
  data_types_struct <- convert_json_to_struct(jsonlite::toJSON(data_types))

  # Ensure output directory exists
  dir.create(output_data_dir, recursive = TRUE)

  # Convert file format
  # Load the CSV file and save to Apache Parquet format.
  # Build SQL query
  query <- stringr::str_glue("
    -- Convert CSV files to Apache Parquet format
    -- DuckDB COPY statement documentation
    -- https://duckdb.org/docs/sql/statements/copy
    COPY (
      SELECT *
      -- Define data types
      -- DuckDB documentation for CSV loading
      -- https://duckdb.org/docs/data/csv/overview.html
      FROM read_csv('{input_glob}',
        header=TRUE,
        filename=TRUE,
        columns={data_types_struct}
      )
    )
    TO '{output_path}'
    WITH (FORMAT 'PARQUET');")

  # Write SQL query to text file
  fileConn <- file(sql_query_file_path)
  writeLines(query, fileConn)
  close(fileConn)
  cli::cli_alert_info("Wrote '{sql_query_file_path}'")

  # Create an in-memory database connection
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")

  cli::cli_alert_info("Reading input data from '{input_glob}'...")

  # Run the query
  affected_rows_count <- DBI::dbExecute(con, query)
  cli::cli_alert_info("{affected_rows_count} rows affected")

  return(output_path)
}

#' Get data types
#'
#' @description
#' Get the data type for each field from the metadata document.
#'
#' @param metadata Nested dictionary. The keys are the field names.
#' @returns Dictionary. Map of field names to data types.
#'
get_data_types <- function(metadata) {
  # Initialise empty dictionary
  field_names <- list()

  # Iterate over list items
  for (field_name in names(metadata)) {
    field_name <- as.character(field_name)
    field <- metadata[[field_name]]
    data_type <- as.character(field$data_type)

    # Build dictionary
    field_names[field_name] <- data_type
  }

  return(field_names)
}

#' Convert JSON object to an SQL struct
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
