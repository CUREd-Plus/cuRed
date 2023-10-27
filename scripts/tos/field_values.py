from collections.abc import Mapping

from nhs_data_model import NHSFormat


class Values:
    """
    TOS field values

    These are the values shown on the 'Values' column of the NHS HES TOS.
    """

    def __init__(self, values):
        self._values_str: str = str(values)
        self._values = None

    def __str__(self):
        return self._values_str

    def __repr__(self):
        return f'Values("""{self._values_str}""")'

    def parse(self):
        for line in self._values_str.splitlines():
            key, _, value = line.partition('=')
            yield key.strip(), value.strip()

    @property
    def nhs_format(self) -> NHSFormat:
        # Get the first value key
        for key in self.values.keys():
            return NHSFormat(key)
        raise ValueError(str(self))

    @property
    def description(self):
        for x in self.values.values():
            return x

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
