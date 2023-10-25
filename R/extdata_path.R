#' Get the path of an external data file
#'
#' @description
#'
#' Build the absolute path of an external data (`extdata`) file in this package.
#'
#' This files are to be found in the `inst/extdata` directory.
#'
#' See: [external data](https://r-pkgs.org/data.html#sec-data-extdata)
#'
#' @param path Character. Path of file within inst/extdata
#' @param mustWork Logical. Raise an error if the file is not found
#'
#' @returns The absolute file path of the file.
#' @export
#'
extdata_path <- function(path = "", mustWork = TRUE) {
  # Get path of a file within inst/extdata
  path <- system.file("extdata", path, package = "cuRed")
  # Ensure the path is absolute and that the file exists
  path <- normalizePath(path, mustWork = mustWork)
  return(path)
}
