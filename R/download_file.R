library(logger)

#' Download a file
#'
#' @description
#' This is a wrapper for [utils::download.file](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file)
#' that has sensible default parameters that make it easier to use in the context of this package.
#'
#' @param url a character string naming the URL of a resource to be downloaded.
#' @param destfile a character string with the name where the downloaded file is saved.
#' @param mode Method to be used for downloading files. See [utils::download.file](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file)
#' @param method Method to be used for downloading files. See [utils::download.file](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file)
#' @param ... Arguments to be passed to utils::download.file(...)
#'
#' @return character. Path of downloaded file (`destfile`)
#'
#' @export
#'
download_file <- function(url, destfile=NA, mode="wb", method="auto", ...) {

  # If file name isn't specified, write to a temporary directory
  if (is.na(destfile)) {
    tmpdir <- temp_dir()
    destfile <- file.path(tmpdir, basename(url))
  }

  # Download file
  # https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file
  result <- utils::download.file(url = url, method = method, destfile = destfile, mode = mode, ...)

  # Raise errors
  if (result != 0) {
    stop("utils::download.file error code: {result}")
  }

  logger::log_success("Wrote '{destfile}'")

  return(destfile)
}
