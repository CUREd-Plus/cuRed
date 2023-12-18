<!-- badges: start -->

[![R-CMD-check](https://github.com/CUREd-Plus/cuRed/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CUREd-Plus/cuRed/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

# cuRed

This respository contains an R package for working with the [CUREd+ research database](https://www.sheffield.ac.uk/cure/database). This package handles the ingress of data and linking between the different data sources. Each directory in this respository should contain `README` files that explain the purpose of that part of the code. There should also be documentation of each function.

This package specifies a workflow, or data pipeline, that is used to process the raw data and produce an integrated database that's ready for research use. The package also contains many useful functions for working with NHS Digital data sets.

# Installation

To install the latest release of this package from [GitHub](https://github.com/), run the following R code:

``` R
install.packages("devtools")
devtools::install_github("CUREd-Plus/cuRed@*release")
```

# Usage

The workflow is designed to run automatically by running the `main()` function, where the only argument is the data set identifier.

```R
# Run the workflow
main("apc")  # Specify data set identifier
```

The configuration file that specifies the input raw data sources is included in the package by default, at `inst/extdata/config/<data_set_id>.yaml`. For example, if you run `main("apc")` then the code will load the following configuration file `extdata/config/apc.yaml`.

You can also set the workflow options by settings the path of a configuration file manually, for example:

```R
main(data_set_config_path = "C:\\Users\\Administrator\\my_data.yaml")
```

Or, for the general workflow options:

```R
main(config_path = "C:\\Users\\Administrator\\my_config.yaml")
```

For more information on using this function, view the documentation by running:

```R
help(cuRed::main)
```

The R code in this package is in the [R directory](./R/) and an overview is available in [R/README.md](R/README.md). Each function has documentation to describe how it works.

# Configuration

The configuration files are contained in the [inst/extdata/config/](./inst/extdata/config/) directory. The main configuration file for the data pipeline is written in a YAML document at [inst/extdata/config/config.yaml](inst/extdata/config/config.yaml) which specifies the options that are relevant for all data sets.

There is also a configuration file that specifies each data set.

## Logs

See the [logging section](CONTRIBUTING.md#Logging) of the contribution documentation.

# Development

To work on this code, please read the [contributing guide](CONTRIBUTING.md).

To publish a new release, please see the [releases section](CONTRIBUTING.md#releases).
