library(arrow)

#' @title Convert CSVW columns metadata to an Arrow schema
#' @description
#' [CSV for the Web](https://w3c.github.io/csvw/syntax/)
#' [Arrow Schema](https://arrow.apache.org/docs/dev/r/reference/Schema.html)
#'
csvw_to_arrow_schema <- function(columns) {
  data_types <- data.frame(columns[, c("name", "datatype")])
  fields <- apply(data_types, 1, csvw_column_to_arrow_field)
  return(arrow::schema(fields))
}

csvw_column_to_arrow_field <- function(column) {
  return(
    arrow::field(
      name = column[['name']],
      type = column[['type']]
      # TODO
    )
  )
}
