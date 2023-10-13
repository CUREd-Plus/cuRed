#' Create a temporary file path
temp_file <- function(...) {
  return(tempfile(tmpdir = temp_dir(), ...))
}
