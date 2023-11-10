/* This is a query template loaded append_mock_ids() */
COPY (
  SELECT
    -- Replicate input data
     input_data.*
      -- Generate mock patient identifiers
    ,uuid() AS token_person_id
    ,uuid() AS yas_id
    ,uuid() AS cured_id
    ,uuid() AS study_id
  FROM read_csv_auto('{input_path}') AS input_data
)
TO '{output_path}'
WITH (FORMAT 'CSV', HEADER);
