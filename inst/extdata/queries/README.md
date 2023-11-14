# SQL queries

This directory contains data processing operations that are defined using structured query language (SQL).

These are loaded up by the data pipeline using R code and used to manipulate the data files.

These queries are written using the [DuckDB dialect of SQL](https://duckdb.org/docs/sql/introduction), which is very similar to standard SQL but with some important differences.

## File operations

[DuckDB](https://duckdb.org/) is an in-process database system that enables us to read data from files that are stored on disk, rather than working with a normal database server.

For example, there is a special DuckDB function for [CSV import](https://duckdb.org/docs/data/csv/overview) that works like so:

```sql
SELECT *
FROM read_csv_auto('my_file.csv')
```

So, instead of reading rows of data from an SQL table, we're loading a CSV file called `my_file.csv` and treating it as if it were an SQL table. The function `read_csv_auto()` has a number of [options](https://duckdb.org/docs/data/csv/overview#parameters) that configure how the CSV file will be parsed.

## Templating

Some of these SQL files use variables to insert different values for different parts of the data pipeline. This is implemented using the R library `stringr` which contains a function [stringr::str_glue()](https://stringr.tidyverse.org/reference/str_glue.html). For example:

```sql
SELECT *
FROM read_csv_auto('{path}')
```

This SQL file will be loaded up by the R code and the value of the variable named `path` will be inserted into the SQL code.