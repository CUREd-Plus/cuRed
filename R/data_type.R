
#' Convert TOS format to an SQL data type
#'
#' See: NHS Digital "Constructing submission files" for the data formats from
#' the NHS Data Model and Dictionary.
#'
#' [DuckDB data types](https://duckdb.org/docs/sql/data_types/overview.html)
#'
#' @param format_str character. TOS format string e.g. "Date(YYYY-MM-DD)" or "Number"
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
    # DuckDB doesn't implement maximum string length
    # i.e. VARCHAR(n) has no effect
    # See: https://duckdb.org/docs/sql/data_types/text
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
    logger::log_error("Unknown field format '{format_str}'")
    stop("Unknown field format")
  }

  return(data_type)
}

#' Convert YAS data type to an SQL data type
#'
#' @description
#'
#' Decide what data type is appropriate to use to store this data type
#' in an SQL database.
#'
#' @param format_str character. Data type e.g. "boolean", "categorical", "numerical"
#'
#' @returns character. [DuckDB data types](https://duckdb.org/docs/sql/data_types/overview.html)
#'
yas_type_to_data_type <- function(format_str) {
  if (format_str == "boolean") {
    return("BOOLEAN")
  } else if (format_str == "numeric") {
    return("UBIGINT")
  } else if (format_str == "time") {
    return("TIME")
  } else {
    return("VARCHAR")
  }
}


#' @title Convert XML schema data type to an SQL data type
#' @description
#' Converts an XML data type to a SQL data type.
#'
#' See:
#'  - [XML Schema data types](https://w3c.github.io/csvw/syntax/#dfn-datatype)
#'  - [DuckDB SQL data types](https://duckdb.org/docs/sql/data_types/overview)
#'
#' @param xml_data_type The XML data type to convert.
#'
#' @return The SQL data type.
#' @export
xml_schema_to_sql_data_type <- function(xml_data_type) {
  # Create dictionary
  data_type_map <- c(
    "string" = "VARCHAR",
    "date" = "DATE",
    "time" = "TIME",
    "float" = "FLOAT",
    "double" = "DOUBLE"
  )
  sql_data_type <- data_type_map[xml_data_type]

  return(sql_data_type)
}


#' @title Convert XML schema data type to an Arrow schema field
#' @description
#' Converts an XML data type to a field type for an Arrow schema.
#'
#' [XML Schema data type](https://w3c.github.io/csvw/syntax/#dfn-datatype) &rightarrow;
#' [Arrow data type](https://arrow.apache.org/docs/r/reference/data-type.html)
#'
#' @param xml_data_type The XML data type to convert.
#'
#' @return The arrow Field
#' @export
xml_schema_to_arrow <- function(xml_data_type) {
  data_type_map <- c(
    "string" = arrow::string(),
    "date" = arrow::date32(),
    "time" = arrow::time32(),
    "dateTime" = arrow::date64(),
    "float" = arrow::float64(),
    "double" = arrow::double(),
    "boolean" = arrow::boolean()
  )
  return(data_type_map[xml_data_type])
}
