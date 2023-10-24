#' Get absolute path for an extdata file in this package
#' https://r-pkgs.org/data.html#sec-data-extdata
#' @param path String. Path.
#' @param mustWork Logical. Raise an error if the file is not found.
extdata_path <- function(filename = "", mustWork = TRUE) {
  # Get path of a file within inst/extdata
  path = system.file("extdata", filename, package = "cuRed")
  # Ensure the path is absolute and that the file exists
  path <- normalizePath(path, mustWork = mustWork)
  return(path)
}
