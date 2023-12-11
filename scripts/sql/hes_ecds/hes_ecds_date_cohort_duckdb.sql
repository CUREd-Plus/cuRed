/*
Check whether any patients are outside of the acceptable cohort date range.

Time period:
start 2017-10-01 (ED types 1 and 2) 2018-10-01 (ED types 3 and 4)
end 2023-03-31
*/
SELECT
   TOKEN_PERSON_ID
  ,EPIKEY
  ,SEEN_DATE
  ,ARRIVAL_DATE
  ,CONCLUSION_DATE
  ,DEPARTURE_DATE
FROM hes_ecds
WHERE  
  greatest(SEEN_DATE, ARRIVAL_DATE, CONCLUSION_DATE, DEPARTURE_DATE) < '2017-10-01'
  OR least(SEEN_DATE, ARRIVAL_DATE, CONCLUSION_DATE, DEPARTURE_DATE) > '2023-03-31'
  -- The visit finished before the start date
  --(CONCLUSION_DATE < '2017-10-01' AND ARRIVAL_DATE < '2017-10-01')
  -- The visit started after the end dat
  --OR (ARRIVAL_DATE > '2023-03-31')
  --OR ARRIVAL_DATE IS NULL
ORDER BY SEEN_DATE;
