#' Create a temporary directory with a random path.
#'
#' The directory will be deleted when the session ends, as tempdir() creates a per-session directory path.
#'
#' On Windows, the temporary directory is determined by the `TEMP` environment variable.
#'
#' R can't handle long path names on Windows, so use a short path.
#' See [issue 75](https://github.com/CUREd-Plus/cuRed/issues/75).
#'
#' This is a wrapper for tempdir(), which is documented here:
#' https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/tempfile
#'
#' @param check logical indicating if temp_dir() should be checked and recreated if no longer valid.
#'
temp_dir <- function(check = FALSE) {
  if (.Platform$OS.type == "windows") {
    windows_temp <- Sys.getenv("TEMP")
    # Build a path with fewer characters
    dir_name <- basename(tempdir())
    path <- file.path(windows_temp, dir_name, fsep = "\\")
    if (check) {
      stop("check is not implemented for windows")
    }
  } else {
    path <- tempdir(check = check)
  }

  # Append a random subdirectory
  path = file.path(path, basename(tempfile(pattern = "")))

  # Make the directory
  dir.create(path, showWarnings = FALSE, recursive = TRUE)

  return(path)
}
