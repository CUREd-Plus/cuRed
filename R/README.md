# R code

This directory contains the [R code](https://r-pkgs.org/code.html) for this package.

# Code structure

The entry-point to the workflow is the `main()` function in [main.R](./main.R). This iterates over the data sets, running `run_workflow()` for each one.

```mermaid
flowchart TD
  main -- "Load configuration" --> run_workflow
  run_workflow --> workflow
    subgraph workflow ["run_workflow()"]
      unzip_files --> csv_to_binary
      csv_to_binary --> validate_data
      validate_data --> summarise
      summarise --> link
    end
```
