import argparse
import logging
from pathlib import Path

logger = logging.getLogger(__name__)

DESCRIPTION = """
TODO
"""

USAGE = """
TODO
"""


def get_args():
    parser = argparse.ArgumentParser(usage=USAGE, description=DESCRIPTION)
    return parser.parse_args()


def main():
    args = get_args()
    logging.basicConfig(level=logging.INFO)

    raise NotImplementedError


if __name__ == '__main__':
    main()
