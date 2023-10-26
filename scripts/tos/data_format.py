"""
This module contains classes that represent and NHS formats and value sets.

These classes may be used as part of the process of generating data validation rules.
"""

import re
from collections.abc import Mapping

from nhs_data_model import NHSFormat

class Format:
    """
    An NHS data format e.g. "Number", "String(4)", "Date(YYYY-MM-DD)"
    """
    def __init__(self, format_):
        self.format = str(format_)

    def __str__(self):
        return self.format

    def generate_expressions(self, field: str):
        """
        Generate R code to validate each field format.
        """
        if self.format == 'Number':
            yield f"is.integer({field})"      
        # String(n)
        elif self.format.startswith('String'):
            yield f"is.character({field}) & nchar({field}) == {self.length}"
        elif self.format == "Date(YYYY-MM-DD)":
            yield f'grepl("^\\d{4}-([0]\\d|1[0-2])-([0-2]\\d|3[01])$", {field})'
        elif self.format == "Decimal":
            yield f"is.numeric({field})"
        else:
            raise NotImplementedError
    
    @property
    def length(self) -> int:
        """
        The length (number of characters or digits) of values in this format.
        """
        # Get numbers only
        try:
            return int(''.join(c for c in self.format if c.isdigit()))
        except ValueError:
            pass


class Values:
    """
    These are the values shown on the 'Values' column of the NHS HES TOS.
    """
    
    def __init__(self, values):
        self._values_str = str(values)
        self._values = None

    def __str__(self):
        return self._values_str

    def __repr__(self):
        return f'Values("""{self._values_str}""")'
    
    def parse(self):
        for line in self._values_str:
            key, _, value = line.partition(' = ')
            yield key, value

    @property
    def nhs_format(self) -> NHSFormat:
        # Get the first value key
        for key in self.values.keys():
            return NHSFormat(key)
        raise ValueError(str(self))
    
    @property
    def values(self) -> Mapping[str, str]:
        if self._values is None:
            self._values = dict(self.parse())
        return self._values

    def __index__(self, x):
        return self.values[x]

    def generate_expressions(self, field):
        # The first value may be an NHS data model format
        yield from self.nhs_format.generate_expressions(field)

        # TODO
        # Further specific values

        # Null values
