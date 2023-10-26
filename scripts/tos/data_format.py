
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



class NHSFormat:
    def regex(self):
        # Regular expression representing this field format
        # e.g. '$[a-zA-Z0-9]{12}' means 12an
        return f"$[a-zA-Z0-9]{{{self.length}}}"
