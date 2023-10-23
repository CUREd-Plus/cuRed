library(utils)

test_that("parse_tos", {
  # Get the Admitted patient care TOS sheet (tab) from the Excel workbook.
  sheet <- "HES APC TOS"

  # Download Technical Output Specification (TOS) spreadsheet for Hospital Episode Statistics (HES)
  # See: https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
  url <- "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"
  tmpdir <- temp_dir()
  # Tidy up (delete temporary files) on exit or failure
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
  tos_path <- tempfile(fileext = ".xlsx", tmpdir = tmpdir)
  # https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file
  utils::download.file(url, method = "auto", destfile = tos_path, mode = "wb")

  # Parse TOS
  expect_no_error(
    parse_tos(tos_path, sheet = sheet)
  )
})
