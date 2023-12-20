import argparse
import csv
import json
import logging
import random
import sys
from collections import OrderedDict
from pathlib import Path
from typing import Generator

DESCRIPTION = """
Generate synthetic data based on the contents of the CSVW document.
"""

USAGE = """
python -m synthetic.csvw metadata/hes_apc.json
"""

logger = logging.getLogger(__name__)


def get_args():
    """
    Command line arguments
    """
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)

    parser.add_argument('path', type=Path, help='CSVW file path')
    parser.add_argument('--table', required=True, help='Table identifier')
    parser.add_argument('--nrows', help='Number of rows to generate', type=int, default=1000)

    return parser.parse_args()


def random_value(datatype: str):
    match datatype:
        case 'string':
            return 'TODO'
        case 'integer':
            return random.randint(0, 1000000)
        case 'date':
            return '1970-01-01'
        case 'time':
            return '00:00:00'


def generate_row(columns):
    for column in columns:
        yield column['name'].upper(), random_value(datatype=column['datatype'])


def generate_rows(columns: list[dict], n_rows: int) -> Generator[None, dict, None]:
    for _ in range(n_rows):
        yield OrderedDict(generate_row(columns))


def main():
    args = get_args()
    logging.basicConfig(level=logging.INFO)

    # Load CSVW document
    with args.path.open() as file:
        data_set = json.load(file)

    # Write CSV data to screen
    writer = None

    # Iterate over tables
    for table in data_set['tables']:
        if table['id'] == args.table:
            # Generate synthetic data
            for row in generate_rows(columns=table['tableSchema']['columns'], n_rows=args.nrows):
                if writer is None:
                    writer = csv.DictWriter(sys.stdout, fieldnames=row.keys())
                    writer.writeheader()
                writer.writerow(row)


if __name__ == '__main__':
    main()
