"""
Generate the SQL script to merge the MHSDS data sets.
"""
import argparse
import logging
from pathlib import Path
from typing import Generator

import pandas

DESCRIPTION = """
The input is a metadata Excel workbook and the output is SQL code. The Excel file is a technical output specification
(TOS) file provided by NHS Digital.
"""

USAGE = """
python -m mhsds /path/to/tos.xlsx > my_query.sql
"""

logger = logging.getLogger(__name__)


def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=DESCRIPTION, usage=USAGE)

    parser.add_argument('path', type=Path, help="Path of the metadata (TOS) Excel workbook")

    return parser.parse_args()


def generate_metadata(path: Path) -> Generator[None, tuple[str, pandas.DataFrame], None]:
    path = path.absolute()
    workbook = pandas.ExcelFile(path)
    logger.info("Loading '%s'", path)
    for sheet_name in workbook.sheet_names:
        if sheet_name.startswith('MHS'):
            df = pandas.read_excel(workbook, sheet_name=sheet_name, skiprows=1, index_col='UID')
            # Skip the first row because there's two header rows
            df = df.iloc[1:, :]
            df = df.dropna(subset='IDB  Element Name')
            yield sheet_name, df
        else:
            logger.debug("Skipping sheet '%s'", sheet_name)


def main():
    args = get_args()
    logging.basicConfig(level=logging.DEBUG)

    joins = list()

    print("SELECT")

    for sheet_name, elements in generate_metadata(path=args.path):
        logger.info(sheet_name)
        print(f"\n  -- {sheet_name}")

        for uid, element in elements.iterrows():
            print(f"  ,{sheet_name}.{element['IDB  Element Name']}")

        join = dict(table=sheet_name, foreign_key=elements.iloc[0]['IDB  Element Name'])
        joins.append(join)

    for join in joins:
        print("LEFT JOIN {table} ON Todo.{foreign_key} = {table}.{foreign_key}".format(**join))

    print(';')


if __name__ == '__main__':
    main()
