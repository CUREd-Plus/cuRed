import argparse
import json
import logging
from pathlib import Path

import pandas

DESCRIPTION = """
"""
USAGE = """
"""

logger = logging.getLogger(__name__)


def tos_to_xmlschema(tos_format):
    """
    Convert a format value from a Technical Output Specification (TOS)
    into a data type from the XML Schema standard.
    https://www.w3.org/TR/xmlschema-2/#datatype
    
    :returns: XML schema data type
    """
    match tos_format:
        case "Date(YYYY-MM-DD)":
            return "date"
        case "Number":
            return "integer"
        case "Decimal":
            return "decimal"
        case "Time(HH24:MI:ss)":
            return "time"
    return "string"


def get_args():
    parser = argparse.ArgumentParser(description=DESCRIPTION, usage=USAGE)
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('tos_path', type=Path, help='Excel workbook file path')
    parser.add_argument('-s', '--sheet_name', required=True, help='Excel tab name e.g. "HES APC TOS"')
    return parser.parse_args()


def main():
    args = get_args()
    logging.basicConfig(
        format="%(name)s:%(asctime)s:%(levelname)s:%(message)s",
        level=logging.INFO if args.verbose else logging.WARNING
    )

    # Get field formats from the TOS
    logger.info("Reading '%s'", args.tos_path)
    tos = pandas.read_excel(args.tos_path, sheet_name=args.sheet_name, skiprows=1, usecols=['Field', 'Format'])
    field_format = tos.set_index('Field')['Format'].str.strip().to_dict()

    # Get XML schema data types
    data_type = {name: tos_to_xmlschema(format_) for name, format_ in field_format.items()}

    print(json.dumps(data_type))


if __name__ == '__main__':
    main()
