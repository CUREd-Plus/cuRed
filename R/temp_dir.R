#' Create a temporary directory
#' 
#' R can't handle long path names on Windows, so use a short path.
#' See [issue 75](https://github.com/CUREd-Plus/cuRed/issues/75).
#' 
#' https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/tempfile
temp_dir <- function(tmpdir = "C:/temp", check = FALSE) {
  if (.Platform$OS.type == "windows") {
    # Build a path with fewer characters
    dir_name = basename(tempdir())
    path <- file.path(tmpdir, dir_name)
  } else {
    path <- tempdir(check = check)
  }
  return(path)
}
