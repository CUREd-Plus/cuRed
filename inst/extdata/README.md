# Package external data files

The `inst/extdata` directory contains data files that may be used to support this code e.g. configuration files, queries, mock data used for automated testing, etc.

The documentation for these files is contained in `R/extdata.R`.

This is a summary of the contents of this directory:

- `config/` contains a configuration file for each input data set that will be processed by the pipeline.
- `metadata/` contains the metadata that describes the data sets.
- `data/` contains raw sythetic sample data, to be used for code testing.
- `queries/` contains SQL queries used to process data as part of the pipeline.
- `validation_rules/` contains metadata definitions used to verify the contents of input data sets
- `patient_id_bridge.csv` is a sample, synthetic patient identifier bridge, to be used for code testing.
- `codes/` contains txt files that store column names that need special attention from all data sources.

# References

- R manual [Documenting data sets](https://cran.r-project.org/doc/manuals/R-exts.html#Documenting-data-sets)
- Wickham, R Packages (2e) [Raw data file](https://r-pkgs.org/data.html#sec-data-extdata)
- roxygen2 [Documenting other objects](https://roxygen2.r-lib.org/articles/rd-other.html)
- Stack Overflow [R and roxygen2: How to document data files in inst/extdata?](https://stackoverflow.com/a/36283724)
