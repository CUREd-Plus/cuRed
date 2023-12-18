
def tos_to_xmlschema(tos_format):
    """
    Convert a format value from a Technical Output Specification (TOS)
    into a data type from the XML Schema standard.
    https://www.w3.org/TR/xmlschema-2/#datatype
    
    :returns: XML schema data type
    """
    match tos_format:
        case "Date(YYYY-MM-DD)":
            return "date"
        case "Number":
         return "integer"
        case "Decimal":
            return "decimal"
        case "Time(HH24:MI:ss)":
            return "time"
    return "string"
