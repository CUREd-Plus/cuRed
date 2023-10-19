test_that("parse_tos", {
  # Get the Admitted patient care TOS sheet (tab) from the Excel workbook.
  sheet <- "HES APC TOS"
  
  # Download Technical Output Specification (TOS) spreadsheet for  Hospital Episode Statistics (HES)
  # See: https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
  url <- "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"
  # https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/tempfile
  tos_path <- tempfile(fileext = ".xlsx")
  # https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file
  download.file(url, method = "auto", destfile = tos_path, mode = "wb")

  # Parse TOS
  expect_no_error(
    parse_tos(tos_path, sheet = sheet)
  )
})
