SELECT setseed(0.0);
COPY (
  SELECT
   uuid() AS study_id
  ,'A1 1AA' AS postcode       
  ,CAST(d['range'] AS DATE) - CAST(random()*999 AS INT) AS postcode_from  
  ,NULL AS postcode_to
  ,1 AS postcode_order 
  ,TRUE as is_current     
  ,'' AS address_line1  
  ,'' AS address_line2  
  ,'' AS address_line3  
  ,'' AS address_line4  
  ,'' AS address_line5  

  -- https://duckdb.org/docs/sql/functions/nested.html
  FROM range(DATE '2000-01-01', DATE '2000-01-10', INTERVAL 1 DAY) AS d
)
TO '{output_path}'
WITH (FORMAT 'PARQUET');
