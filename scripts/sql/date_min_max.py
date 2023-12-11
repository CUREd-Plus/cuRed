headers_csv = ""

delim = "|"

headers = headers_csv.split("|")

for col in headers:
    if 'date' in col.casefold():
        print(f",MIN({col}) AS MIN_{col}")
        print(f",MAX({col}) AS MIN_{col}")
