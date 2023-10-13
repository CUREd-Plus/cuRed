#' Create a temporary directory
temp_dir <- function() {
  # RStudio can't handle long path names, so use a short path on Windows
  # https://github.com/CUREd-Plus/cuRed/issues/75
  if (.Platform$OS.type == "windows") {
    # Use a path with fewer characters
    # https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/tempfile
    new_temp_dir <- tempfile(tmpdir = "C:\\temp")
  } else {
    new_temp_dir <- tempdir()
  }
  dir.create(new_temp_dir, showWarnings = FALSE, recursive = TRUE)
  return(new_temp_dir)
}
