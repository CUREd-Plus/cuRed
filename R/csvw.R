library(coro)
library(jsonlite)


#' Load a [CSVW](https://csvw.org/) document
#' @description
#' Parse the JSON document that contains the [CSVW](https://csvw.org/) metadata for a data set.
#' @param path character. Path of CSVW file
#' @returns Dictionary. CSVW metadata
read.csvw <- function(path) {
  path <- normalizePath(path, mustWork = TRUE)
  logger::log_info("Loading '{path}'")
  csvw <- jsonlite::fromJSON(path)

  logger::log_info("Data set '{csvw$id}', notes '{csvw$notes}'")

  return(csvw)
}


#' Generate CSVW tables
#' @description
#' This is a [generator](https://coro.r-lib.org/#generators) that makes it easy to iterate over the
#' [tables](https://w3c.github.io/csvw/syntax/#tables) that are listed in a [CSVW document](https://csvw.org/).
#' @param metadata CSVW document e.g. `metadata = jsonlite::fromJSON("my_data_set.json")`
#' @returns Iterator of [CSVW tables](https://w3c.github.io/csvw/syntax/#tables)
csvw.tables <- generator(function(metadata) {
  # Iterate over tables
  for (i in seq_len(nrow(metadata$tables))) {
    # Get metadata for this table
    csvw_table <- metadata$tables[i,]

    coro::yield(csvw_table)
  }
})


#' Get [CSVW](https://csvw.org/) columns for a table
#' @param csvw_table [CSVW table](https://w3c.github.io/csvw/syntax/#tables)
#' @returns data.frame [CSVW columns](https://w3c.github.io/csvw/syntax/#columns)
csvw.columns <- function(csvw_table) {
  # Get column info
  columns <- csvw_table$tableSchema$columns[[1]]

  return(columns)
}
