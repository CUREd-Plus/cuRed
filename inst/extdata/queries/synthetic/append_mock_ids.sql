/*
This is a query template loaded by the
function append_mock_ids() that takes a CSV file,
appends some generated IDs, then writes the result
to another CSV file.
*/
SELECT setseed(0.0);
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
