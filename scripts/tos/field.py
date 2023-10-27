import re
from collections.abc import Mapping

from validation_rule import Rule
from field_format import Format
from field_values import Values


class Field:
    """
    A field is a column in a tabular data set.

    A field is represented by a row in the NHS HES TOS.
    https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
    """

    def __init__(self, name: str, title: str, format_: str, values: str = None, required: bool = False,
                 unique: bool = False, description: str = None):
        """
        TOS Field

        :param name: Field name e.g. 'AT_GP_PRACTICE'
        :param title: Pretty, human-readable label for this field.
        """

        self.name = str(name)
        self.title = str(title)
        self.format = Format(format_)
        self.values = Values(values)
        self.required = required
        self.unique = unique
        self.description = str(description or '')

    def __str__(self):
        return self.name

    @property
    def rules(self) -> set:
        return set(self.generate_rules())

    def generate_rules(self):

        if self.required:
            yield Rule(
                name=f"{self} required",
                description=f"{self.title} is required",
                expr=f"!is.na({self})"
            )

        if self.unique:
            yield Rule(
                name=f"{self} unique",
                description=f"{self.title} is unique",
                expr=f"is_unique({self})"
            )

        # Generate rules based on the format (e.g. 'Number', 'String(2)')
        yield Rule(
            name=f'{self} {self.format}',
            description=f"{self.title} is {self.format}".strip(),
            expr=self.format.expr(field=self.name)
        )

        yield from self.values.generate_rules(field=self.name)

    @property
    def length(self) -> int:
        return self.format.length
