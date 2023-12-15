COPY (
  SELECT *
  FROM hes_ecds
  WHERE token_person_id = ''
) TO 'person.json';
