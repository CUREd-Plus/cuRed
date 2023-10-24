#' Get absolute path for an extdata file in this package
#' https://r-pkgs.org/data.html#sec-data-extdata
#' @param path Character. Path of file within inst/extdata
#' @param mustWork Logical. Raise an error if the file is not found
extdata_path <- function(path = "", mustWork = TRUE) {
  # Get path of a file within inst/extdata
  path = system.file("extdata", path, package = "cuRed")
  # Ensure the path is absolute and that the file exists
  path <- normalizePath(path, mustWork = mustWork)
  return(path)
}
