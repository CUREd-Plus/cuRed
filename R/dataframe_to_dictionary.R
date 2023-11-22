#' @title Convert data frame to a dictionary
#'
#' @description
#' Converts the first two columns of data frame to a mapping between the values of the two columns.
#'
#' @param data_frame data.frame to convert.
#' @param key_col The column to use for the dictionary keys
#' @param value_col The column to use as the values
#'
#' @return A dictionary.
#' @export
#' @examples
#' data_frame <- data.frame(name = c("Alice", "Bob", "Charlie"), age = c(30, 25, 42))
#' dictionary <- dataframe_to_dictionary(data_frame, key_col = "name", value_col = "age")
#' print(dictionary)
dataframe_to_dictionary <- function(data_frame, key_col, value_col) {

  dictionary <- list()

  for (i in seq_len(nrow(data))) {
    key <- data_frame[key_col][i,]
    value <- data_frame[value_col][i,]

    # Add the key-value pair to the dictionary
    dictionary[[key]] <- value
  }

  return(dictionary)

}
