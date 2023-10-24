# Raw data files

The `inst/extdata` directory contains data files that may be used to support this code e.g. for automated testing, etc.

The documentation for these data sets is contained in `R/extdata.R`.

This is a summary of the contents of this directory:

- `data/` contains raw sythetic sample data, to be used for code testing.
- `queries/` contains SQL queries used to process data as part of the pipeline.
- `sql_data_types/` contains the data type of each field in each data set, in SQL format
- `validation_rules/` contains metadata definitions used to verify the contents of input data sets
- `data_sets.json` is a configuration file that defines the input data sets to be processed by the pipeline.
- `patient_id_bridge.csv` is a sample, synthetic patient identifier bridge, to be used for code testing.

See:

- R manual [Documenting data sets](https://cran.r-project.org/doc/manuals/R-exts.html#Documenting-data-sets)
- Wickham, R Packages (2e) [Raw data file](https://r-pkgs.org/data.html#sec-data-extdata)
- roxygen2 [Documenting other objects](https://roxygen2.r-lib.org/articles/rd-other.html)
- Stack Overflow [R and roxygen2: How to document data files in inst/extdata?](https://stackoverflow.com/a/36283724)
