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

    # Select which CSVW table to use
    for csvw_table in metadata['tables']:
        if csvw_table['id'] == args.table:
            logger.info("Table identifier '%s'", args.table)
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

    # Specify input files
    input_dir = args.input_dir.absolute()
    source = list(input_dir.glob(csvw_table['url']))
    if not source:
        raise FileNotFoundError(input_dir.joinpath(csvw_table['url']))
    logger.info("Opening dataset '%s'", source)
    data_set = pyarrow.dataset.dataset(source, format=csv_format, schema=schema)

    # Write Parquet format
    output_dir = args.output_dir.absolute()
    logger.info("Writing dataset '%s'", output_dir)
    pyarrow.dataset.write_dataset(data_set, output_dir, format='parquet',
                                  existing_data_behavior='overwrite_or_ignore')

    logger.info("Wrote to '%s'", args.output_dir)


if __name__ == '__main__':
    main()
