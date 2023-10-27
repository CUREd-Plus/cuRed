import argparse
import logging
import os
from pathlib import Path

import pandas as pd
import yaml

from field import Field
from rule import Rule

logger = logging.getLogger(__name__)

DESCRIPTION = """
This script will generate a YAML file that contains validation rules.
"""

USAGE = """
python . --input="my_tos_file.xlsx"
"""

DEFAULT_TOS_PATH = "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"


def get_args():
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)
    parser.add_argument('tos_path', type=Path, help='TOS file path',
                        default=os.getenv('TOS_PATH', DEFAULT_TOS_PATH))
    parser.add_argument('-s', '--sheet_name', help='Tab in the TOS')
    parser.add_argument('-l', '--log_level', default='INFO')
    parser.add_argument('--index_col', default='Field')
    parser.add_argument('--skiprows', default=1, help='Ignore top rows in spreadsheet')
    return parser.parse_args()


def main():
    args = get_args()
    logging.basicConfig(level=args.log_level)

    tos_file = pd.ExcelFile(args.tos_path)

    logger.info(tos_file.sheet_names)

    tos = pd.read_excel(tos_file, sheet_name=args.sheet_name, index_col=args.index_col, skiprows=args.skiprows)

    for row in tos.sample(50).reset_index().replace(pd.NA, None).to_dict(orient='records'):
        field = Field(
            name=row['Field'],
            title=row['Field name'],
            format_=row['Format'],
            values=row['Values'],
            description=row['Description'],
        )

        logger.info(field)
        logger.info(field.values)
        logger.info(repr(field.values.nhs_format))
        for rule in field.generate_rules():
            logger.info(rule)
        logger.info('_' * 128)


if __name__ == '__main__':
    main()
