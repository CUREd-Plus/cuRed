from collections import OrderedDict

class Rule:
    """
    A data validation rule.

    See: Section 8.2 Metadata in text files: YAML
    https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html
    """
    
    def __init__(self, name, expr, description = None):
        self.name = str(name)
        self.description = str(description or '')
        self.expr = str(expr)

    def __repr__(self):
        return f"Rule('{self.name}', description='{self.description}', expr='{self.expr}')"
    
    def __str__(self):
        return self.as_yaml()
    
    def as_yaml(self) -> str:
        """
        Serialise the rule as a YAML data file.
        """
        return yaml.dump(self.as_dict())

    def as_dict(self):
        return OrderedDict(self)
    
    def __iter__(self):
        yield 'name', self.name
        if self.description:
            yield 'description', self.description
        yield 'expr', self.expr
