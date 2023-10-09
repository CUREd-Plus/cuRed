test_that("linkage works", {
  # Get file paths
  # Use the dummy data
  input_path <- normalizePath(system.file("extdata", "artificial_hes_apc_0102.parquet", package="cuRed"), mustWork = TRUE)
  temp_input_path <- tempfile(fileext = ".parquet")
  # Generate a temporary output file
  output_path <- tempfile(fileext = ".parquet")
  patient_path <- normalizePath(system.file("extdata", "patient_id_bridge.csv", package="cuRed"), mustWork = TRUE)
  
  # Append fake patient ID to the HES synthetic data
  run_query(stringr::str_glue("
COPY (
  SELECT
    uuid() AS token_person_id,
    uuid() AS yas_id,
    uuid() AS cured_id,
    apc.*
  FROM read_parquet('{input_path}') AS apc
)
TO '{temp_input_path}'
WITH (FORMAT 'PARQUET');
"))
  
  # Run the data linkage workflow step
  link(
    input_path = temp_input_path,
    output_path = output_path,
    patient_path = patient_path
  )
  
  # Tidy up
  file.remove(output_path)
})
