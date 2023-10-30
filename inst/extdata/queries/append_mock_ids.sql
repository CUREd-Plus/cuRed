/* This is a query template loaded append_mock_ids() */
COPY (
  SELECT
    -- Replicate input data
     input_data.*
      -- Generate mock patient identifiers
    ,'TODO' AS token_person_id
    ,'TODO' AS yas_id
    ,'TODO' AS cured_id
    ,'TODO' AS study_id
  FROM read_csv_auto('{input_path}') AS input_data
)
TO '{output_path}'
WITH (FORMAT 'CSV', HEADER);
