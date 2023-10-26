import re

from rule import Rule
from data_format import Format, Values

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
        self.values = Values(values)
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

        # Generate rules based on the format (e.g. 'Number', 'String(2)')
        for expr in self.format.generate_expressions(field=self.name):
            yield Rule(
                name=f"{self} {self.format}",
                description=f"{self.title} is {self.format}",
                expr=expr
            )

        # Generate rules based on the values
        for expr in self.values.generate_expressions(field=self.name):
            yield Rule(
                name='TODO',
                expr=expr
            )
    
    @property
    def range(self) -> tuple[int]:
        raise NotImplementedError

    @property
    def length(self) -> int:
        return self.format.length
