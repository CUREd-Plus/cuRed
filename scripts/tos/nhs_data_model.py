"""
This module contains utility functions related to the
NHS Data Model and Dictionary    
https://www.datadictionary.nhs.uk/
"""

import re


class NHSFormat:
    """
    NHS data model format e.g. "12an", "4n", etc.

    NHS Data Model and Dictionary    
    https://www.datadictionary.nhs.uk/
    """

    def __init__(self, format_: str):
        self.format = format_

    @property
    def max(self) -> bool:
        """
        Does this format have a length limit,
        e.g. "max 4n" means *up to* 4 digits.
        e.g. "max 2a" means *up to* 2 characters
        """
        return self.format.startswith('max')

    @property
    def length(self) -> int:
        """
        The specified length of this data value,
        e.g. format "4n" has length 4
        e.g. format "12an" has length 12
        """
        raise NotImplementedError
    
    @classmethod
    def is_valid(cls, s: str) -> bool:
        return bool(re.match(r"^\d*a*n*$", s))

    def generate_expressions(self, field: str):
        if self.is_valid(self.format):
            yield f'grepl("{self.regex}", {field})'

    @property
    def regex(self):
        raise NotImplementedError
        # Regular expression representing this field format
        # e.g. '$[a-zA-Z0-9]{12}' means 12an
        return f"$[a-zA-Z0-9]{{{self.length}}}"
