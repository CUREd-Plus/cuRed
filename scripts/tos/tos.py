from collections.abc import Mapping
from pathlib import Path

import pandas


class TechnicalOutputSpecification:
    def __init__(self, path: Path, sheet_name: str, index_col: str = None, skiprows: int = 1):
        index_col = index_col or "Field"
        self.excel_file = pandas.ExcelFile(path)
        self.workbook = pandas.read_excel(self.excel_file, sheet_name=sheet_name, index_col=index_col,
                                          skiprows=skiprows)

    def generate_field_formats(self, format_key: str = None):
        format_key = format_key or 'Format'
        for field_name, field in self.workbook.iterrows():
            yield field_name, field[format_key]

    @property
    def field_formats(self) -> Mapping[str, str]:
        return dict(self.generate_field_formats())
