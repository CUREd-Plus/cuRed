# Automatically test the entire workflow for a single data set
test_that("run_workflow", {
  data_set_id <- "apc"
  raw_data_dir <- extdata_path("data/apc/raw", mustWork = TRUE)
  sheet <- "HES APC TOS"
  patient_path <- extdata_path("patient_id_bridge.csv", mustWork = TRUE)
  staging_dir <- temp_dir()
  dir.create(staging_dir, showWarnings = FALSE, recursive = TRUE)
  demographics_path <- tempfile(fileext = ".parquet", tmpdir = staging_dir)

  # Download Technical Output Specification (TOS) spreadsheet for  Hospital Episode Statistics (HES)
  # See: https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
  url <- "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"
  # https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/tempfile
  tos_path <- tempfile(tmpdir = staging_dir, fileext = ".xlsx")
  # https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file
  # We must specify mode = "wb" for this to work on Windows
  download.file(url, method = "auto", destfile = tos_path, mode = "wb")

  # Generate mock patient demographics data
  run_query(stringr::str_glue("
COPY (
  SELECT
    uuid() AS study_id,
    'SG13' AS derived_postcode_dist,
    'F' AS gender,
    '1970-01' AS dob_year_month
  -- https://duckdb.org/docs/sql/functions/nested.html
  FROM generate_series(1, 10)
)
TO '{demographics_path}'
WITH (FORMAT 'PARQUET');
"))

  # Run the workflow
  expect_no_error(
    run_workflow(
      data_set_id = data_set_id,
      # Load all CSV files in this directory
      raw_data_dir = raw_data_dir,
      metadata_path = tos_path,
      sheet = sheet,
      staging_dir = staging_dir,
      patient_path = patient_path,
      demographics_path = demographics_path
    )
  )

  # Tidy up
  # https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/unlink
  on.exit(unlink(staging_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
})
