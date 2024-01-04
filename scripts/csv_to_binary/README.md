# CSV to Parquet

This is a Python script to convert CSV files to Apache Parquet format using [DuckDB](https://duckdb.org/docs/api/python/overview.html). The metadata of the input CSV files is defined using [CSV on the Web](https://csvw.org/) (CSVW).

# Installation

```bash
python3 -m pip install -r requirements.txt
```

# Usage

To view the usage instructions:

```bash
cd ~/cuRed/scripts
python3 -m csv_to_binary --help
```

## Example

```bash
cd ~/cuRed/scripts
python3 -m csv_to_binary ~/csv_data/ ~/parquet_data/ --csv ~/$data_set_id.json --log ~/csv_to_binary.log
```

