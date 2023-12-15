/*
Check whether any patients are outside of the acceptable cohort date range.

Start	2011-04-01
End 	2020-03-31
*/
SELECT
   token_person_id
  ,epikey
FROM hes_ae
WHERE  
  arrivaldate < '2011-04-01'
  OR arrivaldate > '2020-03-31'
ORDER BY arrivaldate ASC;
