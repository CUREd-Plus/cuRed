# R code

This directory contains the [R code](https://r-pkgs.org/code.html) for this package.

# Code structure

The entry-point to the workflow is the `main()` function in [main.R](./main.R). This iterates over the data sets, running `run_workflow()` for each one.

```mermaid
flowchart TD
  main["main.R::main()"] -->|"for loop"| run_workflow("run_workflow.R::run_workflow(data_set_id)")
  run_workflow --> parse_tos("metadata.R::parse_tos()")
    subgraph workflow ["run_workflow()"]
      parse_tos --> csv_to_binary("csv_to_binary.R::csv_to_binary()")
      csv_to_binary --> ig_validation("validate_data.R::ig_validation()")
      ig_validation --> validate_data("validate_data.R::validate_data()")
      validate_data --> summarise("summarise.R::summarise()")
      summarise --> link("link.R::link()")
    end
```
