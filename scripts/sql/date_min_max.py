headers_csv = ""

delim = "|"

headers = headers_csv.split("|")

for col in headers:
    if 'date' in col.casefold():
        print(f",MIN(NULLIF({col}, '1900-01-01')) AS MIN_{col}")
        print(f",MAX(NULLIF({col}, '1900-01-01')) AS MAX_{col}")
