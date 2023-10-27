import yaml


class Rule:
    """
    A data validation rule.

    See: Section 8.2 Metadata in text files: YAML
    https://cran.r-project.org/web/packages/validate/vignettes/cookbook.html
    """

    def __init__(self, name, expr, description=None):
        """
        :param name: Short rule name
        :param description: Human-readable label
        :param expr: R expression (evaluates to boolean)
        """
        self.name = str(name)
        self.description = str(description or '')
        self.expr = str(expr)

    def __repr__(self):
        return f"Rule('{self.name}', description='{self.description}', expr='{self.expr}')"

    def __str__(self):
        return self.as_yaml()

    @staticmethod
    def yaml_dump(rules: list):
        return yaml.dump(dict(rules=rules))

    def as_yaml(self) -> str:
        """
        Serialise the rule as a YAML data file.
        """
        return yaml.dump(self.as_dict())

    def as_dict(self):
        return dict(self)

    def __iter__(self):
        yield 'name', self.name
        if self.description:
            yield 'description', self.description
        yield 'expr', self.expr
