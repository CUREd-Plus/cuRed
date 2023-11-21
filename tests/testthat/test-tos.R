library(utils)

test_that("parse_tos", {
  # Get the Admitted patient care TOS sheet (tab) from the Excel workbook.
  sheet <- "HES APC TOS"

  # Download Technical Output Specification (TOS) spreadsheet for Hospital Episode Statistics (HES)
  # See: https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
  url <- "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.16.xlsx"
  tmpdir <- temp_dir()
  # Tidy up (delete temporary files) on exit or failure
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
  tos_path <- tempfile(fileext = ".xlsx", tmpdir = tmpdir)
  download_file(url, destfile = tos_path)

  # Parse TOS
  expect_no_error(
    parse_tos(tos_path, sheet = sheet)
  )
})
