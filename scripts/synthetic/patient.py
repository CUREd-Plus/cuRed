import argparse
import csv
import random
import string
import sys

DESCRIPTION = """
A script to generate synthetic patient identifiers
"""


def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=DESCRIPTION)
    parser.add_argument('-s', '--seed', type=int, help='Initialize the random number generator, see random.seed()')
    parser.add_argument('-n', '--nrows', type=int, help='Number of synthetic data rows to produce.', required=True)

    return parser.parse_args()


def random_string(length: int = 1) -> str:
    return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(length))


def get_patient():
    return dict(
        # Random 6 or 7 digital integer
        study_id=random.randint(1E5, 1E7),
        # Random 15 character alphanumeric uppercase string
        pseudo_person_id=random_string(length=15)
    )


def generate_patients(nrows: int):
    for _ in range(nrows):
        yield get_patient()


def main():
    args = get_args()

    buffer = sys.stdout
    writer = None

    if args.seed:
        random.seed(args.seed)

    for patient in generate_patients(nrows=args.nrows):
        # Initalise CSV writer (we need the header so we can only do this after we know the dict keys)
        if writer is None:
            writer = csv.DictWriter(f=buffer, fieldnames=patient.keys())
            writer.writeheader()
        writer.writerow(patient)


if __name__ == "__main__":
    main()
