import json
from pathlib import Path

from tos.tos import TechnicalOutputSpecification
from tos_to_xmlschema import tos_to_xmlschema

TOS_PATH = "~/Downloads/HES+TOS+V1.16.xlsx"
SHEET_NAME = "HES APC TOS"


tos_path = Path(TOS_PATH).expanduser().absolute()

tos = TechnicalOutputSpecification(tos_path, SHEET_NAME)


field_formats = tos.field_formats

# Convert to XML Schema data types
field_xml_data_types = {field_name: tos_to_xmlschema(field_format)
    for field_name, field_format in field_formats.items()}

# Convert to SQL data types
with open("xmlschema_to_sql.json") as file:
    xmlschema_to_sql = json.load(file)
field_sql_types = {field_name: xmlschema_to_sql[data_type]
    for field_name, data_type in field_xml_data_types.items()}

print(json.dumps(field_sql_types, indent=2))
