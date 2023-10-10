#' Load TOS files
#'
#' @param xls_file str Path File to Excel file from which TOS are to be loaded.
#' @param sheet str Name of worksheet to be loaded.
#' @param sheet_number int Number of worksheet to be loaded
#' @export
#'
load_xls <- function(xls_file, sheet = "HES APC TOS", sheet_number = NA) {
  myCols <- as.character(read_excel(xls_file, sheet, n_max = 1, skip = 1, col_names = FALSE))
  # Get data only and attached the cols names
  var_list <- c("Field", "Field name", "Format", "Availability", "Values")
  my_data <- read_excel(xls_file, sheet, skip = 2, col_names = myCols)
  my_data2 <- select(my_data, all_of(var_list))
  my_data2 <- my_data2[!apply(my_data2 == "", 1, all), ]
  return(my_data2)
}

#' write dataframe to json
#'
#' @param df dataframe(tibble)
#' @param outputdir str
#' @param json_file str
#' @export
df2json <- function(df, outputdir, json_file) {
  if (!dir.exists(file.path(outputdir))) {
    dir.create(outputdir)
  }
  write_json(df, file.path(outputdir, json_file))
}
