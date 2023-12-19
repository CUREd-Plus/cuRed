/*
Convert CSV files to Parquet files.
*/

-- Configure DuckDB
-- https://duckdb.org/docs/archive/0.5.1/sql/configuration.html

-- Use virtual memory
SET temp_directory = '/tmp';
--SET log_query_path = 'duckdb_query.log';

-- https://duckdb.org/dev/profiling
--SET enable_profiling = 'json';
--SET profile_output = 'profiling.json';

-- Read CSV files
COPY (
  SELECT *
  -- Create partition keys
	,YEAR(arrivaldate) AS arrival_year
	,STRFTIME(arrivaldate, '%Y-%m') AS arrival_month
  FROM read_csv('{path}',
          delim='|', header=TRUE,
          -- Add source filename as a column
          filename=TRUE,
          -- Columns must be ordered
          columns={'ACTIVAGE': 'UBIGINT', 'AEARRIVALMODE': 'VARCHAR', 'AEATTENDCAT': 'VARCHAR', 'AEATTENDDISP': 'VARCHAR', 'AEDEPTTYPE': 'VARCHAR', 'AEINCLOCTYPE': 'VARCHAR', 'AEKEY': 'VARCHAR', 'AEPATGROUP': 'VARCHAR', 'AEREFSOURCE': 'VARCHAR', 'AESTAFFCODE': 'VARCHAR', 'ARRIVALAGE': 'UBIGINT', 'ARRIVALAGE_CALC': 'UBIGINT', 'ARRIVALDATE': 'DATE', 'ARRIVALTIME': 'VARCHAR', 'AT_GP_PRACTICE': 'VARCHAR', 'CANNET': 'VARCHAR', 'CANREG': 'VARCHAR', 'CARERSI': 'VARCHAR', 'CCG_GP_PRACTICE': 'VARCHAR', 'CCG_RESIDENCE': 'VARCHAR', 'CCG_RESPONSIBILITY': 'VARCHAR', 'CCG_TREATMENT': 'VARCHAR', 'CONCLDUR': 'UBIGINT', 'CONCLTIME': 'VARCHAR', 'DEPDUR': 'UBIGINT', 'DEPTIME': 'VARCHAR', 'DIAG_01': 'VARCHAR', 'DIAG_02': 'VARCHAR', 'DIAG_03': 'VARCHAR', 'DIAG_04': 'VARCHAR', 'DIAG_05': 'VARCHAR', 'DIAG_06': 'VARCHAR', 'DIAG_07': 'VARCHAR', 'DIAG_08': 'VARCHAR', 'DIAG_09': 'VARCHAR', 'DIAG_10': 'VARCHAR', 'DIAG_11': 'VARCHAR', 'DIAG_12': 'VARCHAR', 'DIAG2_01': 'VARCHAR', 'DIAG2_02': 'VARCHAR', 'DIAG2_03': 'VARCHAR', 'DIAG2_04': 'VARCHAR', 'DIAG2_05': 'VARCHAR', 'DIAG2_06': 'VARCHAR', 'DIAG2_07': 'VARCHAR', 'DIAG2_08': 'VARCHAR', 'DIAG2_09': 'VARCHAR', 'DIAG2_10': 'VARCHAR', 'DIAG2_11': 'VARCHAR', 'DIAG2_12': 'VARCHAR', 'DIAG3_01': 'VARCHAR', 'DIAG3_02': 'VARCHAR', 'DIAG3_03': 'VARCHAR', 'DIAG3_04': 'VARCHAR', 'DIAG3_05': 'VARCHAR', 'DIAG3_06': 'VARCHAR', 'DIAG3_07': 'VARCHAR', 'DIAG3_08': 'VARCHAR', 'DIAG3_09': 'VARCHAR', 'DIAG3_10': 'VARCHAR', 'DIAG3_11': 'VARCHAR', 'DIAG3_12': 'VARCHAR', 'DIAGSCHEME': 'VARCHAR', 'DOMPROC': 'VARCHAR', 'EPIKEY': 'VARCHAR', 'GPPRAC': 'VARCHAR', 'HRGNHS': 'VARCHAR', 'HRGNHSVN': 'VARCHAR', 'IMD04': 'DOUBLE', 'IMD04_DECILE': 'VARCHAR', 'IMD04C': 'DOUBLE', 'IMD04ED': 'DOUBLE', 'IMD04EM': 'DOUBLE', 'IMD04HD': 'DOUBLE', 'IMD04HS': 'DOUBLE', 'IMD04I': 'DOUBLE', 'IMD04IA': 'DOUBLE', 'IMD04IC': 'DOUBLE', 'IMD04LE': 'DOUBLE', 'IMD04RK': 'UBIGINT', 'INITDUR': 'UBIGINT', 'INITTIME': 'VARCHAR', 'INVEST_01': 'VARCHAR', 'INVEST_02': 'VARCHAR', 'INVEST_03': 'VARCHAR', 'INVEST_04': 'VARCHAR', 'INVEST_05': 'VARCHAR', 'INVEST_06': 'VARCHAR', 'INVEST_07': 'VARCHAR', 'INVEST_08': 'VARCHAR', 'INVEST_09': 'VARCHAR', 'INVEST_10': 'VARCHAR', 'INVEST_11': 'VARCHAR', 'INVEST_12': 'VARCHAR', 'INVEST2_01': 'VARCHAR', 'INVEST2_02': 'VARCHAR', 'INVEST2_03': 'VARCHAR', 'INVEST2_04': 'VARCHAR', 'INVEST2_05': 'VARCHAR', 'INVEST2_06': 'VARCHAR', 'INVEST2_07': 'VARCHAR', 'INVEST2_08': 'VARCHAR', 'INVEST2_09': 'VARCHAR', 'INVEST2_10': 'VARCHAR', 'INVEST2_11': 'VARCHAR', 'INVEST2_12': 'VARCHAR', 'LSOA01': 'VARCHAR', 'LSOA11': 'VARCHAR', 'MSOA01': 'VARCHAR', 'MSOA11': 'VARCHAR', 'MYDOB': 'VARCHAR', 'NODIAGS': 'UBIGINT', 'NOINVESTS': 'UBIGINT', 'NOTREATS': 'UBIGINT', 'OACODE11': 'VARCHAR', 'PGPPRAC': 'VARCHAR', 'PROCODE': 'VARCHAR', 'PROCODE3': 'VARCHAR', 'PROCODE5': 'VARCHAR', 'PROCODET': 'VARCHAR', 'PROTYPE': 'VARCHAR', 'RESCTY_ONS': 'VARCHAR', 'RESGOR_ONS': 'VARCHAR', 'RESLADST_ONS': 'VARCHAR', 'RURURB_IND': 'VARCHAR', 'SEX': 'VARCHAR', 'SUSHRG': 'VARCHAR', 'SUSHRGINFO': 'VARCHAR', 'SUSHRGVERINFO': 'VARCHAR', 'SUSHRGVERS': 'VARCHAR', 'SUSLDDATE': 'DATE', 'SUSRECID': 'UBIGINT', 'SUSSPELLID': 'VARCHAR', 'Token_Person_ID': 'VARCHAR', 'TREAT_01': 'VARCHAR', 'TREAT_02': 'VARCHAR', 'TREAT_03': 'VARCHAR', 'TREAT_04': 'VARCHAR', 'TREAT_05': 'VARCHAR', 'TREAT_06': 'VARCHAR', 'TREAT_07': 'VARCHAR', 'TREAT_08': 'VARCHAR', 'TREAT_09': 'VARCHAR', 'TREAT_10': 'VARCHAR', 'TREAT_11': 'VARCHAR', 'TREAT_12': 'VARCHAR', 'TREAT2_01': 'VARCHAR', 'TREAT2_02': 'VARCHAR', 'TREAT2_03': 'VARCHAR', 'TREAT2_04': 'VARCHAR', 'TREAT2_05': 'VARCHAR', 'TREAT2_06': 'VARCHAR', 'TREAT2_07': 'VARCHAR', 'TREAT2_08': 'VARCHAR', 'TREAT2_09': 'VARCHAR', 'TREAT2_10': 'VARCHAR', 'TREAT2_11': 'VARCHAR', 'TREAT2_12': 'VARCHAR', 'TREAT3_01': 'VARCHAR', 'TREAT3_02': 'VARCHAR', 'TREAT3_03': 'VARCHAR', 'TREAT3_04': 'VARCHAR', 'TREAT3_05': 'VARCHAR', 'TREAT3_06': 'VARCHAR', 'TREAT3_07': 'VARCHAR', 'TREAT3_08': 'VARCHAR', 'TREAT3_09': 'VARCHAR', 'TREAT3_10': 'VARCHAR', 'TREAT3_11': 'VARCHAR', 'TREAT3_12': 'VARCHAR', 'TRETDUR': 'UBIGINT', 'TRETTIME': 'VARCHAR'}
  )
)

/*
Write Parquet partitions
https://duckdb.org/docs/data/parquet/overview
https://duckdb.org/docs/data/partitioning/partitioned_writes
https://duckdb.org/docs/data/parquet/tips.html

This will use all available cores.
*/

TO '~/data/hes_ae/raw/hes_ae_parquet'
-- https://duckdb.org/docs/sql/statements/copy.html#parquet-options
WITH (
   FORMAT 'PARQUET'
  ,PARTITION_BY (arrival_year, arrival_month)
  ,OVERWRITE_OR_IGNORE
  ,COMPRESSION 'snappy'
  ,ROW_GROUP_SIZE 122880
);
