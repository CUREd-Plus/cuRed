# SQL data types

This directory files contain JSON files that are used to configure the data type, in SQL, for each field (column) in each data set.

Each files contains key-value pairs, for example:

```json
{
  "token_person_id": "VARCHAR",
  "yas_id": "VARCHAR"
}
```

This means that the field `token_person_id` contains data of the string type, which is represented by [VARCHAR](https://duckdb.org/docs/sql/data_types/text.html) in SQL.

