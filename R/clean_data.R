library(arrow)
library(logger)

#' @title Clean a data set
#' @description
#' Apply data cleaning rules to a data set.
#' 
#' This is implemented using the [Arrow R package](https://arrow.apache.org/docs/r/).
#' 
#' @param input_dir Path of the directory containing the input data
#' @param output_dir Path of the directory containing the output data
#' @param format See [`arrow::open_dataset`](https://arrow.apache.org/docs/r/reference/open_dataset.html)
#' 
#' @export
clean_data <- function(input_dir, output_dir, format = "parquet") {
  # Set working directories
  input_dir = normalizePath(input_dir, mustWork = TRUE)
  output_dir = normalizePath(output_dir, mustWork = FALSE)
  fs::dir_create(output_dir, recurse = TRUE)
  
  # Open data set
  # https://arrow.apache.org/docs/r/articles/dataset.html
  logger::log_info("Opening '{input_dir}'")
  # This create a Dataset instance
  # https://arrow.apache.org/docs/r/reference/Dataset.html
  data_set <- arrow::open_dataset(input_dir, format = format)
  
  logger::log_info(data_set$schema)
}
