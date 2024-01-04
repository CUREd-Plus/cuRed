library(arrow)
library(logger)


#' @title Clean a data set
#' @description
#' Apply data cleaning rules to a data set.
#'
#' The transformations are defined using [dplyr mutate](https://dplyr.tidyverse.org/reference/mutate.html) syntax.
#'
#' This is implemented using the [Arrow R package](https://arrow.apache.org/docs/r/).
#' 
#' @param input_dir Path of the directory containing the input data
#' @param data_set_id Data set identifier e.g. "hes_apc", "yas_epr"
#' @param output_dir Path of the directory containing the output data
#' @param format See [`arrow::open_dataset`](https://arrow.apache.org/docs/r/reference/open_dataset.html)
#' 
#' @export
clean_data <- function(input_dir, data_set_id, output_dir, format = "parquet") {
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
  
  if (data_set_id == "hes_ae") {
    data_set = clean_data_hes_op(data_set)
  } else {
    logger::log_error("No rules defined for data set {data_set_id}")
    stop(data_set_id)
  }
}

clean_data_hes_op <- function(data_set) {
  data_set = data_set %>%
    mutate()
  
  return(data_set)
}
