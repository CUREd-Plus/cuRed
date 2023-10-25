# Data validation rules

We're using the [validate](https://cran.r-project.org/web/packages/validate/index.html) R package for data validation. This defines a collection of rules that the data must conform to.

The files in this directory are used to define these sets of rules to be applied to check that data are valid.

The files are written in [YAML](https://en.wikipedia.org/wiki/YAML) format, which is loaded by the data pipeline.

There is one file per data set, e.g. `apc.yaml`, `op.yaml`, `ae.yaml`, etc. where the filename is the data set identifier.

See:
- [The Data Validation Cookbook](https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html) by Mark P.J. van der Loo
