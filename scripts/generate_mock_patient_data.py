import csv
import random

DESCRIPTION = """
A script to generate synthetic patient identifiers
"""

def get_patient():
    raise NotImplemented
    return dict(
        # Random 6 or 7 digital integer
        study_id=1,
        # Random 15 character alphanumeric uppercase string
        pseudo_person_id='fdfs'
    )

def generate_patients(n: int):
    for i in range(n):
        yield get_patient()

def main():
    # TODO
    writer = csv.DictWriter()

    for patient in generate_patients():
        writer.write_row(patient)
    

if __name__ == "__main__":
    main()
