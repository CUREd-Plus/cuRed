"""
This module contains classes that represent and NHS formats and value sets.

These classes may be used as part of the process of generating data validation rules.
"""

import logging
import re
from collections.abc import Mapping
from nhs_data_model import NHSFormat

logger = logging.getLogger(__name__)


class Format:
    """
    An NHS HES TOS field data format e.g. "Number", "String(4)", "Date(YYYY-MM-DD)", "String(6-40000)"
    """

    def __init__(self, format_):
        self.format = str(format_)

    def __str__(self):
        return self.format

    def __repr__(self):
        return f'{self.__class__.__name__}({repr(self.format)})'

    def expr(self, field: str) -> str:
        """
        The R expression of the data validation rule for this field.
        """
        # Assume we can represent this field format using a single expression
        if self.format == 'Number':
            return f"is.integer({field})"
            # String(n)
        elif self.format.startswith('String'):
            return f"is.character({field}) & {self.nchar(field)}"
        elif self.format == "Date(YYYY-MM-DD)":
            return f'grepl("^\\d{4}-([0]\\d|1[0-2])-([0-2]\\d|3[01])$", {field})'
        elif self.format == "Decimal":
            return f"is.numeric({field})"
        else:
            logger.error("%s %s", field, repr(self))
            raise NotImplementedError(self.format)

    def nchar(self, field: str) -> str:
        """
        Build character length check logical expression in the R programming language.
        """
        try:
            # Fixed length e.g. "nchar(MY_FIELD) == 2"
            return f"nchar({field}) == {self.length}"

        except ValueError:
            try:
                # Range of acceptable lengths
                min_, max_ = self.range
                return f"({min_} <= nchar({field})) & (nchar({field}) <= {max_})"
            except ValueError:
                # Handle wierd cases e.g.
                """"String(12) (2013-14 to 2020-21)
                String(19) (2021-22 onwards)"""

                # Grab all possible values
                lengths = re.findall(r"String\((\d+)\)", self.format)
                # nchar(FIELD) == 12 OR nchar(FIELD) == 19
                nchar = ' | '.join((f"nchar({field}) == {n}" for n in lengths))
                # Wrap logical expressions in brackets to form a single expression
                return f"({nchar})"

    @property
    def range(self) -> tuple[int, int]:
        """
        The range of lengths for this field
        """
        # String(4-6000)
        if self.format.startswith('String('):
            s = self.format[7:-1]
            n_min, _, n_max = s.partition('-')
            n_min = int(n_min)
            n_max = int(n_max)
            if n_min >= n_max:
                raise ValueError("Invalid range %s", self.format)
            return n_min, n_max

        raise NotImplementedError(self.format)

    def is_string(self) -> bool:
        return self.format.startswith('String(')

    @property
    def length(self) -> int:
        """
        The length (number of characters or digits) of values in this format.
        """
        # Get numbers only
        if self.is_string():
            # 'String(42)' -> '42'
            s = self.format[7:-1]
            return int(s)
        else:
            raise NotImplementedError(self.format)
