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

    def __str__(self):
        return self.format

    def __repr__(self):
        return f'{self.__class__.__name__}({repr(self.format)})'

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
        The specified length of this data value, e.g.:
        {
          "4n": 4,
          "12an": 12,
          "max 20an": 20
        }
        """

        match = re.search(r"^(?:max )?(\d+)[an]+$", self.format)
        groups = match.groups()
        if len(groups) != 1:
            raise ValueError(groups)

        length = int(groups[0])

        return length

    def generate_expressions(self, field: str):
        yield f'grepl("{self.regex}", {field})'

    @property
    def regex(self):

        # Date
        if self.format == 'YYYY-MM-DD':
            return r"^((?:19|20)\d\d)[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$"

        # Alphanumeric e.g. {'12an', 'an', '3an', 'max 20an'}
        elif self.match(r"^(max )?\d+a+n*$"):
            # Regular expression representing this field format
            length_regex = f"{{{self.length}}}"  # Fixed length
            if self.max:
                length_regex = f"{{0,{self.length}}}"  # Up to x characters
            # '^[a-zA-Z0-9]{12}$' means 12an
            return f"^[a-zA-Z0-9]{length_regex}$"

        # Integer {'n', '2n', 'max 4n'}
        elif self.match(r"^(max )?\d*n+$"):
            regex = r"\d"
            if self.max:
                pass
            return rf"^{regex}$"

        # Decimal
        elif self.match(r"^n+\.n+"):
            return r"^\d*\.?\d*$"

        # Fixed string format e.g. ann aan aann
        elif self.match(r"^a*n*$"):
            regex = str()
            num_a = self.format.count('a')
            if num_a:
                regex += fr"[a-zA-Z]{{{num_a}}}"
            num_b = self.format.count('n')
            if num_b:
                regex += fr"\d{{{num_b}}}"
            return rf"^{regex}$"

        else:
            raise NotImplementedError(self.format)

    def match(self, pattern, **kwargs) -> bool:
        """
        Does the format match the Regular Expression pattern?
        """
        return bool(re.match(pattern=pattern, string=self.format, **kwargs))
