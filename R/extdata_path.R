#' Get absolute path for an extdata file in this package
#' https://r-pkgs.org/data.html#sec-data-extdata
#' @param path String. Path.
#' @param mustWork Logical. Raise an error if the file is not found.
extdata_path <- function(path, mustWork=TRUE) {
  path <- normalizePath(system.file("extdata", path, package = "cuRed"), mustWork = mustWork)
  return(path)
}
