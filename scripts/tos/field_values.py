import itertools
import logging
from collections.abc import Mapping
from typing import Optional

from nhs_data_model import NHSFormat
from validation_rule import Rule

logger = logging.getLogger(__name__)


class Values:
    """
    TOS field values

    These are the values shown on the 'Values' column of the NHS HES TOS.
    """

    DELIMITER = '='
    "The string that separates the codes and values, on each line of the cell."

    def __init__(self, values):
        self._values_str: str = str(values).replace('\r\n', '\n')
        self._data: Optional[Mapping] = None

    def __str__(self):
        return self._values_str

    def __repr__(self):
        return f'Values("""{self._values_str}""")'

    @classmethod
    def parse(cls, values):

        for i, line in enumerate(values.splitlines()):
            key, _, value = line.partition(cls.DELIMITER)

            # Store lines that aren't mappings as "comments"
            if not value:
                logger.warning("Values line %s '%s'", i, line)
                continue

            yield key.strip(), value.strip()

    def keys(self):
        return self.data.keys()

    def values(self):
        return self.data.values()

    def items(self):
        return self.data.items()

    @property
    def nhs_format(self) -> NHSFormat:
        # Get the first value key
        for key in self.keys():
            return NHSFormat(key)

    @property
    def description(self):
        for x in self.values.values():
            return x

    @property
    def data(self) -> Mapping[str, str]:
        if self._data is None:
            self._data = dict(self.parse(values=self._values_str))
        return self._data

    def __index__(self, x):
        return self.values[x]

    def __len__(self):
        return len(self.data)

    def generate_rules(self, field: str):

        # NHS Format
        # The first value may be an NHS data model format
        try:
            yield Rule(
                name=f"{field} {self.nhs_format}",
                expr=self.nhs_format.expr(field),
                description=f"{field} NHS Data Model and Dictionary"
            )
        # Some values don't have an NHS format specified
        except (NotImplementedError, AttributeError):
            pass

        # Avoid cases without a code list
        if len(self) > 1:
            # Generate rules based on the values (code list)
            yield Rule(
                name=f"{field} values codes",
                expr=self.expr(field),
                description=str(self)
            )

    def expr(self, field: str) -> str:
        """
        Generate expression

        `validate` code lists
        https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html#28_Code_lists
        """
        return f'{field} %in% c({self.expr_in})'

    @property
    def expr_in(self) -> str:
        return ', '.join(repr(x) for x in self.codes.keys())

    def _codes(self):
        """
        Generate the possible codes (and their values) in this value set.
        """
        # Iterate over values
        for i, (code, value) in enumerate(self.data.items()):
            # TODO
            # How can we differentiate between codes and formats?
            yield code, value

    @property
    def codes(self):
        return dict(self._codes())
