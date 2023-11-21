
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/CUREd-Plus/cuRed/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CUREd-Plus/cuRed/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

# cuRed

This respository contains an R package for working with CUREd+ data. This package handles the ingress of data and linking between the different data sources. Each directory in this respository should contain `README` files that explain the purpose of that part of the code. There should also be documentation of each function.

This package specifies a workflow, or data pipeline, that is used to process the raw data and produce an integrated database that's ready for research use. The package also contains many useful functions for working with NHS Digital data sets.

# Installation

To install the latest development version of this package from [GitHub](https://github.com/), run the following R code:

``` R
install.packages("devtools")
devtools::install_github("CUREd-Plus/cuRed")
```

# Usage

The workflow is designed to run automatically by running the `main()` function.

```R
data_set_id <- "apc" # specify data set identifier
cuRed::main(data_set_id)
```

The configuration file that specifies the input raw data sources is included in the package by default, at `inst/extdata/data_sets.json`. You can manually specify this using the `data_sets_path` argument. For more information on using this function, view the documentation by running:

```R
help(cuRed::main)
```

# Development

To work on this code, please read the [contributing guide](CONTRIBUTING.md).
