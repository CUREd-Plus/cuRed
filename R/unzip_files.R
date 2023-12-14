library(fs)
library(logger)


#' @title Extract ZIP files from a specified directory
#'
#' @description
#' Recursively extracts all ZIP files found in a specified directory.
#'
#' @param dir_path The path to the directory containing the ZIP files to extract.
#' @param glob A pattern to match the ZIP file names. The default pattern is "*.zip", which matches all ZIP files.
#'
#' @return A vector of paths to the extracted files.
#'
unzip_files <- function(dir_path, glob = "*.zip") {
  # Ensure path exists and is an absolute path
  dir_path = normalizePath(dir_path, mustWork = TRUE)

  # Find all the ZIP files in the target directory
  paths <- fs::dir_ls(path = dir_path, glob = glob)

  all_unzipped_files = c()

  # Iterate over .zip files
  for (path in paths) {
    logger::log_info("Extracting '{path}'...")

    # Extract file in the same place as the input archive
    unzipped_files <- utils::unzip(
      zipfile = path,
      exdir = dir_path
    )

    for (unzipped_path in unzipped_files) {
      logger::log_success("Extracted '{unzipped_path}'")
    }

    all_unzipped_files <- append(all_unzipped_files, unzipped_files)
  }

  return(all_unzipped_files)
}
