import itertools
import logging
from collections.abc import Mapping
from typing import Optional

from nhs_data_model import NHSFormat

logger = logging.getLogger(__name__)


class Values:
    """
    TOS field values

    These are the values shown on the 'Values' column of the NHS HES TOS.
    """

    DELIMITER = '='
    "The string that delimit the codes and values"

    def __init__(self, values):
        self._values_str: str = str(values).replace('\r\n', '\n')
        self._values: Optional[Mapping] = None

    def __str__(self):
        return self._values_str

    def __repr__(self):
        return f'Values("""{self._values_str}""")'

    def __iter__(self):
        yield from self.parse(self._values_str)

    @classmethod
    def parse(cls, values):

        for i, line in enumerate(values.splitlines()):
            key, _, value = line.partition(cls.DELIMITER)

            # Store lines that aren't mappings as "comments"
            if not value:
                logger.warning("Values line %s '%s'", i, line)
                continue

            yield key.strip(), value.strip()

    @property
    def nhs_format(self) -> NHSFormat:
        # Get the first value key
        for key in self.values.keys():
            return NHSFormat(key)

    @property
    def description(self):
        for x in self.values.values():
            return x

    @property
    def values(self) -> Mapping[str, str]:
        if self._values is None:
            self._values = dict(self)
        return self._values

    def __index__(self, x):
        return self.values[x]

    def generate_expressions(self, field):
        try:
            # The first value may be an NHS data model format
            yield from self.nhs_format.generate_expressions(field)
        # Some values don't have an NHS format specified
        except AttributeError:
            if self.nhs_format is not None:
                raise

        # Code lists: specific values
        # https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html#28_Code_lists
        yield self.expr(field)

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
        for code, value in itertools.islice(self, 1, None):
            if code.startswith('*'):
                raise ValueError("%s %s", code, value)
            yield code, value

    @property
    def codes(self):
        return dict(self._codes())
