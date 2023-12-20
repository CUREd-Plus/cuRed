import argparse
import csv
import logging
import sys
from pathlib import Path
from typing import Generator

import bs4

logger = logging.getLogger(__name__)


def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument('html_path', type=Path, help='Metadata HTML file path')
    return parser.parse_args()


def generate_rows(soup) -> Generator[tuple, None, None]:
    # Find the metadata HTML elements
    for row in soup.find_all('div', role="row"):
        yield (grid_cell.string for grid_cell in row.find_all('div', role='gridcell'))


def main():
    args = get_args()
    logging.basicConfig(level=logging.INFO)

    # Load the HTML file
    with args.html_path.open() as file:
        soup = bs4.BeautifulSoup(file, 'html.parser')
        logger.info("Reading '%s'", file.name)

    # Write to CSV
    writer = csv.writer(sys.stdout)
    for row in generate_rows(soup):
        writer.writerow(row)


if __name__ == '__main__':
    main()
