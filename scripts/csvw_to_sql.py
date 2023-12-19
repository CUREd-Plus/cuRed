#!/bin/env python3

import argparse
import logging
import json
from pathlib import Path

DESCRIPTION = """
Load a CSVW metadata document and get the SQL data types for the columns. 
"""

USAGE = """
python csvw_to_sql.py /path/to/csvw.json
"""

DATA_TYPE_MAP_PATH = Path("xmlschema_to_sql.json")

logger = logging.getLogger(__name__)


def get_args():
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)

    parser.add_argument('csvw_path', type=Path, help='Path of CSVW document')

    return parser.parse_args()


def main():
    args = get_args()

    logging.basicConfig(level=logging.INFO)

    # Load data type mapping
    with DATA_TYPE_MAP_PATH.open() as file:
        data_type_map = json.load(file)

    # Load CSVW document
    with args.csvw_path.open() as file:
        csvw_doc = json.load(file)

    # Iterate over tables
    for table in csvw_doc['tables']:
        logger.info("Table %s", table['id'])

        columns = {col['name']: col['datatype'] for col in table['tableSchema']['columns']}
        sql_columns = {name: data_type_map[data_type] for name, data_type in columns.items()}

        print(sql_columns)


if __name__ == '__main__':
    main()
