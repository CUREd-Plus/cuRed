library(stringr)

#' Convert a dictionary to an [SQL struct](https://duckdb.org/docs/sql/data_types/struct.html)
#'
#' @export
#'
#' @param dictionary List. dictionary, key-value pairs.
#' @returns SQL struct (text data)
dictionary_to_struct <- function(dictionary) {
  
  items <- vector()
  
  # Iterate over the key-value pairs of the dictionary
  for (key in names(dictionary)) {
    value <- dictionary[[key]]
    
    item <- stringr::str_glue("'{key}': '{value}'")
    items <- c(items, item)
  }
  
  items_char <- stringr::str_flatten_comma(items)
  struct <- stringr::str_glue("{{{items_char}}}", collapse = "", sep = "")
  return(struct)
}
