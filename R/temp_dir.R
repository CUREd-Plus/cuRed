#' Create a random path for a temporary directory.
#' 
#' This *doesn't* create the directory. To do so, use dir.create.
#'
#' R can't handle long path names on Windows, so use a short path.
#' See [issue 75](https://github.com/CUREd-Plus/cuRed/issues/75).
#'
#' This is a wrapper for tempdir(), which is documented here:
#' https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/tempfile
#'
#' @param check logical indicating if temp_dir() should be checked and recreated if no longer valid.
#' 
#' @examples
#' my_directory <- temp_dir()
#' dir.create(my_directory)
#' 
temp_dir <- function(check = FALSE) {
  if (.Platform$OS.type == "windows") {
    # Build a path with fewer characters
    dir_name <- basename(tempdir())
    path <- file.path("C:\\temp", dir_name, fsep = "\\")
    if (check) {
      stop("check is not implemented for windows")
    }
  } else {
    path <- tempdir(check = check)
  }
  return(path)
}
