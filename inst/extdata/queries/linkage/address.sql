/*
Historic address query

The query has the following steps:

1. Merge the input data set with the historic address data
   This creates duplicate records, one per historic address
2. De-duplicate, keeping only the most recent address
3. Save to output file
*/

-- Step 3: save to disk
COPY (

  -- Step 1: Merge data sets
  WITH linked_data AS (
    SELECT
      data_set.*
      
      -- Historic address
      ,address.postcode
      ,address.postcode_from
      ,address.postcode_to
      ,address.address_line1
      ,address.address_line2
      ,address.address_line3
      ,address.address_line4
      ,address.address_line5
      
      -- Get the latest matching address using a Window FUNCTION
      -- https://duckdb.org/docs/sql/window_functions.html
      ,row_number() OVER (
        PARTITION BY address.study_id
        ORDER BY postcode_from DESC
      ) AS address_order
    
    FROM read_parquet('{input_path}') AS data_set

    -- Merge with historic address records
    LEFT JOIN read_parquet('{address_path}') AS address
      ON data_set.study_id = address.study_id
        -- Exclude future addresses
        AND address.postcode_from <= data_set.{date_column}
  )

  -- Step 2: De-duplicate, keeping only the most recent address
  SELECT *
  FROM linked_data
  WHERE address_order = 1
)
TO '{output_path}';
