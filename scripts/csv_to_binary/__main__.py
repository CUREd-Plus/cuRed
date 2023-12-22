import argparse
import datetime
import json
import logging
import os
import time
from pathlib import Path

import boto3.session
import pyarrow.csv
import pyarrow.dataset
import pyarrow.fs

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

ARROW_IO_THREADS = os.getenv('ARROW_IO_THREADS', 8)


def get_args():
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)

    # Input options
    parser.add_argument('base_dir', type=str, help='Input S3 bucket directory URI')
    parser.add_argument('--profile_name', help='AWS CLI profile name', default='default')
    parser.add_argument('--csvw', type=Path, help='CSVW document path', required=True)
    parser.add_argument('--table', help='CSVW table identifier')

    # Output options
    parser.add_argument('output_dir', type=Path, help='Output data directory path')

    # Performance options
    parser.add_argument('-i', '--io_thread_count', type=int, help='IO thread count', default=ARROW_IO_THREADS)

    return parser.parse_args()


def column_to_field(column: dict) -> pyarrow.Field:
    return pyarrow.field(
        name=column['name'],
        type=XML_SCHEMA_TO_ARROW_DATA_TYPE[column['datatype']]
    )


def get_columns(csvw_path: Path, table_id: str = None) -> list[dict]:
    """
    Get the column metadata for a CSV data set.

    :param csvw_path: Path of the CSVW document.
    :param table_id: Identifier of the table
    :return: Columns [{"name": "my_col_1", "datatype": "string"}]
    """
    # Load metadata
    with csvw_path.open() as file:
        metadata = json.load(file)
        logger.info("Loaded '%s'", file.name)

    # Select which CSVW table to use
    tables = metadata['tables']
    if not table_id:
        table = tables[0]
    else:
        for table in tables:
            if table['id'] == table_id:
                logger.info("Table identifier '%s'", args.table)
                break
            raise ValueError(table_id)

    return table['tableSchema']['columns']


def get_s3_file_system(profile_name: str = None) -> pyarrow.fs.S3FileSystem:
    # Configure AWS credentials
    session = boto3.session.Session(profile_name=profile_name)
    credentials = session.get_credentials()

    # Configure S3 file system
    # https://arrow.apache.org/docs/python/filesystems.html#filesystem-s3
    return pyarrow.fs.S3FileSystem(
        secret_key=credentials.secret_key,
        access_key=credentials.access_key,
        region=session.region_name,
        session_token=credentials.token
    )


def main():
    args = get_args()
    logging.basicConfig(level=logging.INFO, format='%(levelname)s:%(name)s:%(asctime)s:%(message)s')

    # Read CSV metadata
    columns = get_columns(args.csvw, table_id=args.table)

    # Build schema to describe the fields in the input data set
    schema = pyarrow.schema(fields=(column_to_field(column) for column in columns))

    # Set parallel options
    pyarrow.set_io_thread_count(args.io_thread_count)
    logger.info("IO pool: %s threads", pyarrow.io_thread_count())

    # Connect to the S3 bucket
    s3 = get_s3_file_system(args.profile_name)

    # List input files that comprise the data set
    logger.info("Listing files in '%s'", args.base_dir)
    file_info: pyarrow.fs.FileInfo
    for file_info in s3.get_file_info(pyarrow.fs.FileSelector(base_dir=str(args.base_dir))):
        logger.info(file_info.path)

    # Read CSV data
    # https://arrow.apache.org/docs/python/csv.html
    csv_format = pyarrow.dataset.CsvFileFormat(
        parse_options=pyarrow.csv.ParseOptions(
            delimiter=metadata['dialect']['delimiter'],
        )
    )

    data_set = pyarrow.dataset.dataset(source, format=csv_format, schema=schema)

    # Modify values to calculate the partition key
    # for table_chunk in data_set.to_batches():
    #     pass

    # Write Parquet format
    output_dir = args.output_dir.absolute()

    logger.info("Writing dataset '%s'", output_dir)
    t0 = time.time()
    pyarrow.dataset.write_dataset(
        data_set, output_dir, format='parquet',
        # existing_data_behavior='overwrite_or_ignore',
        # partitioning=partitioning
    )
    duration = datetime.timedelta(time.time() - t0)
    logger.info("Time elapsed: %s", str(duration))
    logger.info("Wrote to '%s'", args.output_dir)


if __name__ == '__main__':
    main()
