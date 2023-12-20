library(coro)
library(fs)
library(stringr)


test_that("csvw_to_arrow_schema", {
  metadata_dir <- extdata_path(stringr::str_glue("metadata/raw"))
  paths <- fs::dir_ls(metadata_dir, glob = "*.json")
  csv_metadata_path <- paths[1]
  csv_metadata <- read.csvw(csv_metadata_path)

  coro::loop(for (csv_table in csvw.tables(csv_metadata)) {
    columns <- csvw.columns(csvw_table)
    expect_no_error(
      csvw_to_arrow_schema(columns)
    )
  }
})
