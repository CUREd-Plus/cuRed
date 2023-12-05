library(logger)
library(stringr)
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

  # Generate dummy data
  raw_data_glob = file.path(extdata_path("data/apc/raw", mustWork = TRUE), "*.csv")
  output_path = file.path(staging_dir, stringr::str_glue("artificial_hes_apc_appended.csv"))
  query <- stringr::str_glue("SELECT setseed(0.0); COPY (
  SELECT
     uuid() AS token_person_id
    ,uuid() AS study_id
    ,artificial_apc.*
  FROM read_csv_auto('{raw_data_glob}') AS artificial_apc
)
TO '{output_path}'
WITH (FORMAT 'CSV', HEADER);
")
  run_query(query)
  logger::log_info("Wrote '{output_path}'")

  # Generate mock patient demographics data
  demographics_path <- file.path(staging_dir, "demographics.parquet")
  generate_demographics(demographics_path)

  # Run the workflow
  expect_no_error(
    run_workflow(
      data_set_id = data_set_id,
      raw_data_dir = staging_dir,
      metadata_path = "",
      sheet = sheet,
      staging_dir = staging_dir,
      patient_path = patient_path,
      demographics_path = demographics_path,
      patient_key = "token_person_id"
    )
  )

})
