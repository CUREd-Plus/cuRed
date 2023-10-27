import argparse
import json
import logging
import os
from pathlib import Path

import pandas as pd
import yaml

from field import Field
from validation_rule import Rule

logger = logging.getLogger(__name__)

DESCRIPTION = """
This script will generate a YAML file that contains validation rules.
"""

USAGE = """
python . --input="my_tos_file.xlsx"
"""

DEFAULT_TOS_PATH = "https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.15.xlsx"

DEFAULT_FIELD_FORMAT_OVERRIDES_PATH = Path('./field_format_overrides.json').absolute()


def get_args():
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)
    parser.add_argument('tos_path', type=Path, help='TOS file path',
                        default=os.getenv('TOS_PATH', DEFAULT_TOS_PATH))
    parser.add_argument('-s', '--sheet_name', help='Tab in the TOS')
    parser.add_argument('-l', '--log_level', default='INFO')
    parser.add_argument('--index_col', default='Field')
    parser.add_argument('--skiprows', default=1, help='Ignore top rows in spreadsheet')
    parser.add_argument('-f', '--field_format_overrides_path', type=Path, help='Manually specify Format',
                        default=DEFAULT_FIELD_FORMAT_OVERRIDES_PATH)
    return parser.parse_args()


def main():
    args = get_args()
    logging.basicConfig(level=args.log_level)

    tos_file = pd.ExcelFile(args.tos_path)
    logger.info("Loaded '%s'", args.tos_path)
    logger.info("Worksheets: %s", tuple(tos_file.sheet_names))

    tos = pd.read_excel(tos_file, sheet_name=args.sheet_name, index_col=args.index_col, skiprows=args.skiprows)

    # Load manually-specific field formats
    with args.field_format_overrides_path.open() as file:
        field_format_overrides = json.load(file)
        logger.info("Read '%s'", file)

    # Build a set of rules
    rules = list()
    # Iterate over fields in the TOS
    rows = tos.reset_index().replace(pd.NA, str()).to_dict(orient='records')
    for i, row in enumerate(rows):
        i += 1
        logger.info("Row %s '%s'", i, row['Field'])

        # Insert manually specified format
        format_ = field_format_overrides.get(row['Field'], row['Format'])

        field = Field(
            name=row['Field'].strip(),
            title=row['Field name'],
            format_=format_,
            values=row['Values'],
            description=row['Description'],
        )

        for rule in field.generate_rules():
            rules.append(dict(rule))

    # Output results
    rules_data = yaml.dump(dict(rules=rules))
    print(rules_data)


if __name__ == '__main__':
    main()
