library(utils)

# Automatically test the entire workflow for a single data set
test_that("run_workflow", {
  data_set_id <- "apc"
  sheet <- "HES APC TOS"
  patient_path <- extdata_path("patient_id_bridge.csv", mustWork = TRUE)
  # Create temporary working directory
  staging_dir <- temp_dir()
  # Tidy up on exit/failure
  on.exit(unlink(staging_dir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
  demographics_path <- file.path(staging_dir, "demographics.parquet")

  # Generate dummy data
  append_mock_ids(
    input_path = file.path(extdata_path("data/apc/raw", mustWork = TRUE), "*.csv"),
    output_path = file.path(staging_dir, stringr::str_glue("{data_set_id}_raw_appended.csv"))
  )

  # Download Technical Output Specification (TOS) spreadsheet
  # See: https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
  url <- "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"
  tos_path <- file.path(staging_dir, basename(url))
  # We must specify mode = "wb" for this to work on Windows
  utils::download.file(url, method = "auto", destfile = tos_path, mode = "wb")

  # Generate mock patient demographics data
  run_query(stringr::str_glue("
COPY (
  SELECT
     '?' AS PATIENT_CARE_EXTENSION
    ,'?' AS ADDRESS_LINE1
    ,'?' AS ADDRESS_LINE2
    ,'?' AS ADDRESS_LINE3
    ,'?' AS ADDRESS_LINE4
    ,'?' AS ADDRESS_LINE5
    ,'?' AS ADDRESS_TYPE
    ,'AA11 1AA' AS POSTCODE
    ,'?' AS DEATH_NOTIFICATION_STATUS
    ,'?' AS DERIVED_FOR_DODYM
    ,'?' AS DERIVED_INF_DODYM
    ,'AA11' AS DERIVED_POSTCODE_DIST
    ,'?' AS DERIVED_RFR
    ,'1970-01' AS DOB_YEAR_MONTH
    ,'?' AS GENDER
    ,'?' AS GP_PDS_BUS_EFF_FROM
    ,'?' AS NHAIS_PDS_BUS_EFF_FROM
    ,'?' AS RFR_PDS_BUS_EFF_FROM

  -- https://duckdb.org/docs/sql/functions/nested.html
  FROM generate_series(1, 10)
)
TO '{demographics_path}'
WITH (FORMAT 'PARQUET');
"))
  cli::cli_alert_info("Wrote '{demographics_path}'")

  # Run the workflow
  expect_no_error(
    run_workflow(
      data_set_id = data_set_id,
      # Load all CSV files in this directory
      raw_data_dir = staging_dir,
      metadata_path = tos_path,
      sheet = sheet,
      staging_dir = staging_dir,
      patient_path = patient_path,
      demographics_path = demographics_path
    )
  )

})
