# CSV to Parquet

This is a Python script that can be used to efficiently convert from CSV files to Apache Parquet format using the Arrow library (via the Python API called `pyarrow`.)

# Installation

Install Python

```bash
sudo apt install python3.11 python3-pip
```

Install the Python packages required to run this code.

```bash
python3.11 -m pip install -r csv_to_binary/requirements.txt
```

Install the [AWS Command Line Interface](https://aws.amazon.com/cli/) (CLI).

```bash
sudo apt install awscli
```

Configure your AWS CLI credentials.

```bash
aws configure
```



# Usage

To view the instructions on using this tool:

```bash
python3.11 -m csv_to_binary --help
```

Example:

```bash
python3.11 -m csv_to_binary -i 32 --csvw ~/cuRed/inst/extdata/metadata/raw/apc.json --table apc curedplus-raw.store.rcc.shef.ac.uk/NHSD-DATA/HES_APC/ ~/data
```

