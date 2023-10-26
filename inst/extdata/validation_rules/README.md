# Data validation rules

We're using the [validate](https://cran.r-project.org/web/packages/validate/index.html) R package for data validation. This defines a collection of rules that the data must conform to. To learn how to use this package, please read [*The Data Validation Cookbook*](https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html) by Mark P.J. van der Loo.

The files in this directory are used to define these sets of rules to be applied to check that data are valid. The files are [written in YAML format](https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html#82_Metadata_in_text_files:_YAML), which is loaded by the data pipeline. There is one file per data set, e.g. `apc.yaml`, `op.yaml`, `ae.yaml`, etc. where the filename is the data set identifier.

# NHS data formats

The data types codes, such as `10n`, are used by the [NHS Data Model and Dictionary](https://www.datadictionary.nhs.uk/). For example:

| Type | Meaning                                |
| ---- | -------------------------------------- |
| 12an | Alphanumeric string with 12 characters |
| 6n   | A number with six digits               |

# Regular expressions

Some of the validation rules use [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) (regex) to perform more complex string pattern matching. This is done using the [`grepl` function](https://rdrr.io/r/base/grep.html) which returns a logical `TRUE` value if the input string matches the pattern. For example:

```R
# Match any string
x <- "My value"
pattern <- ".*"
grepl(pattern, x) # TRUE
```

There are several online tools, such as [regex101](https://regex101.com/), that may be used to help develop regex patterns. You can also ask ChatGPT to help you.

