#!/usr/bin/env python

import argparse
import json
import logging
import tempfile
import time
from pathlib import Path

import duckdb

DESCRIPTION = """
CSV on the Web https://csvw.org/ is the metadata standard for the input CSV files.
DuckDB is used to process the data. https://duckdb.org/docs/api/python/overview
Apache Parquet is a binary file format https://parquet.apache.org/
"""
USAGE = """
python -m csv_to_binary ~/csv_data/ ~/parquet_data/ --csv ~/$data_set_id.json --table $table_id
"""

logger = logging.getLogger(__name__)

XML_SCHEMA_TO_SQL = dict(
    string='VARCHAR',
    date='DATE',
    time='TIME',
    dateTime='TIMESTAMP',
    long='BITINT',
    integer='UBIGINT',
    float='FLOAT',
    boolean='BOOLEAN',
    double='DOUBLE',
    decimal='DECIMAL',
)
"""
https://www.w3.org/2001/sw/rdb2rdf/wiki/Mapping_SQL_datatypes_to_XML_Schema_datatypes
Map from XML Schema data types https://www.w3.org/TR/xmlschema-2/#typesystem
to DuckDB SQL data types https://duckdb.org/docs/sql/data_types/overview.html
"""


def get_args():
    parser = argparse.ArgumentParser(description=DESCRIPTION, usage=USAGE)

    # Logging
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('-l', '--log', type=Path, help='Log file path')

    # Input options
    parser.add_argument('input_dir', type=Path, help='Path of the directory that contains the input CSV data files.')
    parser.add_argument('-c', '--csv', type=Path, required=True,
                        help='Path of the CSVW document https://w3c.github.io/csvw/syntax/#table-groups', )
    parser.add_argument('-t', '--table', required=False,
                        help='CSVW table identifier https://w3c.github.io/csvw/syntax/#dfn-table-id')
    parser.add_argument('--delim', default='|', help='CSV delimeter')
    parser.add_argument('--database', default=':memory:', help='DuckDB database')

    # Output options
    parser.add_argument('output_dir', type=Path,
                        help='Path of the directory that will contain the output Parquet data files.')

    return parser.parse_args()


def main():
    args = get_args()
    logging.basicConfig(
        filename=args.log,
        format="%(name)s:%(asctime)s:%(levelname)s:%(message)s",
        level=logging.DEBUG if args.verbose else logging.INFO,
    )

    # Get column data types
    # Load CSV metadata
    with args.csv.open() as file:
        csvw = json.load(file)
        logger.info("Loaded '%s'", file.name)

    # Get the CSVW table (a data set comprises a group of tables)
    if args.table:
        for table in csvw['tables']:
            if table['id'] == args.table:
                break
    else:
        # Default to first table
        table = csvw['tables'][0]

    # Get column data types (in SQL format)
    # https://duckdb.org/docs/sql/data_types/overview.html
    columns = table['tableSchema']['columns']
    data_types = {col['name']: col['datatype'] for col in columns}
    data_types = {name: XML_SCHEMA_TO_SQL[data_type] for name, data_type in data_types.items()}

    temp_directory = Path(tempfile.mkdtemp())
    log_query_path = temp_directory.joinpath('query_log.sql')
    logger.info("Writing DuckDB SQL logs to '%s'", log_query_path)

    # Iterate over input CSV files
    input_dir = args.input_dir.absolute()
    glob = table['url']
    output_dir = args.output_dir.absolute()

    with duckdb.connect(':memory:') as con:
        logger.info(con)
        for input_path in input_dir.glob(glob):
            logger.info(input_path)

            output_path = output_dir.joinpath(input_path.stem + '.parquet')

            # Build SQL query
            query = f"""
    -- Convert CSV files to Apache Parquet format
    
    -- Configure DuckDB
    -- https://duckdb.org/docs/archive/0.5.1/sql/configuration.html
    SET temp_directory = '{temp_directory}';
    SET log_query_path = '{log_query_path}';
    
    -- DuckDB COPY statement documentation
    -- https://duckdb.org/docs/sql/statements/copy
    COPY (
      SELECT *
      -- Define data types
      -- DuckDB documentation for CSV loading
      -- https://duckdb.org/docs/data/csv/overview.html
      FROM read_csv('{input_path}',
        header=TRUE, delim='{args.delim}'
        -- Add a column for input filename
        ,filename=TRUE
        -- Columns must be ordered
        ,columns={data_types}
      )
    )
    TO '{output_path}';
        """

            # Execute query
            logger.info("Executing script '%s'", log_query_path)
            logger.info('Converting to binary file format...')
            logger.info("Writing '%s'", output_path)
            start_time = time.time()
            result = con.execute(query)
            logger.info("Duration: %s", str(time.time() - start_time))
            logger.info(result)


if __name__ == '__main__':
    main()
