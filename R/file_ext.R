#' Get the file extension
#' @export
#' @param path File path
#' @returns File extension of the file `path`
file_ext <- function(path) {
  # Get the file name
  filename <- basename(path)
  # Get the file extension
  ext <- strsplit(filename, split = "\\.")[[1]][-1]
  return(ext)
}
