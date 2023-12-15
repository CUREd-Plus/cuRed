test_that("unzip_files", {
  # Create dummy test files
  tmpdir <- temp_dir()
  #on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE), add = TRUE, after = FALSE)
  setwd(tmpdir)

  # Create a dummy file
  path <- "test.txt"
  readr::write_file("Hello, world!", path)

  # Compress a file
  zip_path <- fs::path(tmpdir, "test.zip")
  utils::zip(zip_path, files = c(path))

  # Run the code
  expect_no_error(
    unzip_files(tmpdir)
  )
})
