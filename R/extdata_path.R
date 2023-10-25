#' Get an extdata file path
#'
#' @description
#' This function builds the absolute path for an extdata file in this package.
#'
#' See: [Raw data file](https://r-pkgs.org/data.html#sec-data-extdata) in *R Packages* by H. Wickham.
#'
#' @param path Character. The relative path of file within inst/extdata.
#' @param mustWork Logical. Raise an error if the file is not found
#' @export
#' @returns character. The file path
extdata_path <- function(path = "", mustWork = TRUE) {
  # Get path of a file within inst/extdata
  path <- system.file("extdata", path, package = "cuRed")
  # Ensure the path is absolute and that the file exists
  path <- normalizePath(path, mustWork = mustWork)
  return(path)
}
