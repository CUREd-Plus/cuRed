from collections.abc import Mapping
from collections import OrderedDict
import re

from rule import Rule
from data_format import Format

class Field:
    """
    A field is a column in a tabular data set.
    """
    
    def __init__(self, title, name, format_: str, values: str = None, required: bool = False, unique: bool = False, description: str = None):
        """
        Field

        :param name: Field name e.g. 'AT_GP_PRACTICE'
        :param title: Pretty, human-readable label for this field.
        """
        self.name = str(name)
        self.title = str(title)
        self.format = Format(format_)
        self._values = str(values or '')
        self.required = required
        self.unique = unique
        self.description = str(description or '')

    @property
    def rules(self) -> set:
        return set(self.generate_rules())

    def __str__(self):
        return self.name
    
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

        # Generate rules for the format (e.g. 'Number', 'String(2)')
        for expr in self.format.generate_expressions(field=self.name):
            yield Rule(
                name=f"{self} {self.format}",
                description=f"{self.title} is {self.format}",
                expr=expr
            )
    
    @property
    def range(self) -> tuple[int]:
        raise NotImplementedError

    def parse_values(self):
        for line in self._values.splitlines():
            key, _, value = line.partition(' = ')
            yield key, value
    
    @property
    def values(self) -> Mapping[str, str]:
        return OrderedDict(self.parse_values())
    
    @property
    def length(self) -> int:
        return self.format.length
