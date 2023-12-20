import argparse
import json
import logging
from pathlib import Path

import pyarrow.dataset
import pyarrow.csv

logger = logging.getLogger(__name__)

DESCRIPTION = """
TODO
"""

USAGE = """
python csv_to_parquet.py ~/csv_dir/ ~/parquet_dir/ --csvw apc.json --table apc
"""

XML_SCHEMA_TO_ARROW_DATA_TYPE = dict(
    string=pyarrow.string(),
    date=pyarrow.date32(),
    time=pyarrow.time32('s'),
    datetime=pyarrow.date64(),
    integer=pyarrow.int64(),
    decimal=pyarrow.float64(),
)


def get_args():
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)

    parser.add_argument('input_dir', type=Path, help='Input data directory path')
    parser.add_argument('output_dir', type=Path, help='Output data directory path')
    parser.add_argument('--csvw', type=Path, help='CSVW document path', required=True)
    parser.add_argument('--table', help='CSVW table identifier', required=True)

    return parser.parse_args()


def column_to_field(column: dict) -> pyarrow.Field:
    return pyarrow.field(
        name=column['name'],
        type=XML_SCHEMA_TO_ARROW_DATA_TYPE[column['datatype']]
    )


def main():
    args = get_args()
    logging.basicConfig(level=logging.INFO)

    # Load metadata
    with args.csvw.open() as file:
        metadata = json.load(file)
        logger.info("Loaded '%s'", file.name)

    for csvw_table in metadata['tables']:
        if csvw_table['id'] == args.table:
            break
        raise ValueError(args.table)

    columns = csvw_table['tableSchema']['columns']

    # Read CSV data
    # https://arrow.apache.org/docs/python/csv.html
    schema = pyarrow.schema(fields=(column_to_field(column) for column in columns))
    csv_format = pyarrow.dataset.CsvFileFormat(
        parse_options=pyarrow.csv.ParseOptions(
            delimiter=metadata['dialect']['delimiter'],
        ),
        read_options=pyarrow.csv.ReadOptions(
            skip_rows=1 if metadata['dialect']['header'] else 0
        )
    )
    logger.info("Opening dataset '%s'", args.input_dir)
    data_set = pyarrow.dataset.dataset(args.input_dir, format=csv_format, schema=schema)

    # Write Parquet format
    logger.info("Writing dataset '%s'", args.output_dir)
    pyarrow.dataset.write_dataset(data_set, args.output_dir, format='parquet',
                                  existing_data_behavior='overwrite_or_ignore')

    logger.info("Wrote to '%s'", args.output_dir)


if __name__ == '__main__':
    main()
