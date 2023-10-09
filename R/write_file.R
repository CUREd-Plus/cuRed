library(cli)

#' Serialise text data to a file
#' 
#' @param file_path Target text file path.
#' @param string Text data to write.
#' 
write_file <- function(file_path, data) {
  file_path <- normalizePath(file.path(file_path), mustWork = FALSE)

  # Open file
  fileConn <- file(file_path)

  # Write data to file
  writeLines(data, fileConn)

  close(fileConn)

  cli::cli_alert_info("Wrote '{file_path}'")
}
