#'
#' Parse Technical Output Specification (TOS) metadata file.
#'
#' @param metadata_path String path. The metadata file i.e. TOS spreadsheet file path.
#'
#' @export
#'
parse_tos <- function(metadata_path) {
  metadata_path <- normalizePath(metadata_path, mustWork = TRUE)

  # TODO
  # Create an empty data frame for now
  metadata <- as.data.frame(list())

  return(metadata)
}
