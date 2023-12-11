/* DuckDB CSV import
https://duckdb.org/docs/data/csv/overview.html
*/

SELECT
   COUNT(*) AS row_count
  ,MIN(ARRIVAL_DATE) AS MIN_ARRIVAL_DATE
  ,MAX(ARRIVAL_DATE) AS MAX_ARRIVAL_DATE
  ,MIN(ASSESSMENT_DATE) AS MIN_ASSESSMENT_DATE
  ,MAX(ASSESSMENT_DATE) AS MAX_ASSESSMENT_DATE
  ,MIN(CONCLUSION_DATE) AS MIN_CONCLUSION_DATE
  ,MAX(CONCLUSION_DATE) AS MAX_CONCLUSION_DATE
  ,MIN(DECIDED_TO_ADMIT_DATE) AS MIN_DECIDED_TO_ADMIT_DATE
  ,MAX(DECIDED_TO_ADMIT_DATE) AS MAX_DECIDED_TO_ADMIT_DATE
  ,MIN(DEPARTURE_DATE) AS MIN_DEPARTURE_DATE
  ,MAX(DEPARTURE_DATE) AS MAX_DEPARTURE_DATE
  ,MIN(EXPIRY_DATE_1) AS MIN_EXPIRY_DATE_1
  ,MAX(EXPIRY_DATE_1) AS MAX_EXPIRY_DATE_1
  ,MIN(EXPIRY_DATE_2) AS MIN_EXPIRY_DATE_2
  ,MAX(EXPIRY_DATE_2) AS MAX_EXPIRY_DATE_2
  ,MIN(EXPIRY_DATE_3) AS MIN_EXPIRY_DATE_3
  ,MAX(EXPIRY_DATE_3) AS MAX_EXPIRY_DATE_3
  ,MIN(EXPIRY_DATE_4) AS MIN_EXPIRY_DATE_4
  ,MAX(EXPIRY_DATE_4) AS MAX_EXPIRY_DATE_4
  ,MIN(INJURY_DATE) AS MIN_INJURY_DATE
  ,MAX(INJURY_DATE) AS MAX_INJURY_DATE
  ,MIN(INVESTIGATION_DATE_1) AS MIN_INVESTIGATION_DATE_1
  ,MAX(INVESTIGATION_DATE_1) AS MAX_INVESTIGATION_DATE_1
  ,MIN(INVESTIGATION_DATE_10) AS MIN_INVESTIGATION_DATE_10
  ,MAX(INVESTIGATION_DATE_10) AS MAX_INVESTIGATION_DATE_10
  ,MIN(INVESTIGATION_DATE_11) AS MIN_INVESTIGATION_DATE_11
  ,MAX(INVESTIGATION_DATE_11) AS MAX_INVESTIGATION_DATE_11
  ,MIN(INVESTIGATION_DATE_12) AS MIN_INVESTIGATION_DATE_12
  ,MAX(INVESTIGATION_DATE_12) AS MAX_INVESTIGATION_DATE_12
  ,MIN(INVESTIGATION_DATE_2) AS MIN_INVESTIGATION_DATE_2
  ,MAX(INVESTIGATION_DATE_2) AS MAX_INVESTIGATION_DATE_2
  ,MIN(INVESTIGATION_DATE_3) AS MIN_INVESTIGATION_DATE_3
  ,MAX(INVESTIGATION_DATE_3) AS MAX_INVESTIGATION_DATE_3
  ,MIN(INVESTIGATION_DATE_4) AS MIN_INVESTIGATION_DATE_4
  ,MAX(INVESTIGATION_DATE_4) AS MAX_INVESTIGATION_DATE_4
  ,MIN(INVESTIGATION_DATE_5) AS MIN_INVESTIGATION_DATE_5
  ,MAX(INVESTIGATION_DATE_5) AS MAX_INVESTIGATION_DATE_5
  ,MIN(INVESTIGATION_DATE_6) AS MIN_INVESTIGATION_DATE_6
  ,MAX(INVESTIGATION_DATE_6) AS MAX_INVESTIGATION_DATE_6
  ,MIN(INVESTIGATION_DATE_7) AS MIN_INVESTIGATION_DATE_7
  ,MAX(INVESTIGATION_DATE_7) AS MAX_INVESTIGATION_DATE_7
  ,MIN(INVESTIGATION_DATE_8) AS MIN_INVESTIGATION_DATE_8
  ,MAX(INVESTIGATION_DATE_8) AS MAX_INVESTIGATION_DATE_8
  ,MIN(INVESTIGATION_DATE_9) AS MIN_INVESTIGATION_DATE_9
  ,MAX(INVESTIGATION_DATE_9) AS MAX_INVESTIGATION_DATE_9
  ,MIN(PERIOD_END_DATE) AS MIN_PERIOD_END_DATE
  ,MAX(PERIOD_END_DATE) AS MAX_PERIOD_END_DATE
  ,MIN(PERIOD_START_DATE) AS MIN_PERIOD_START_DATE
  ,MAX(PERIOD_START_DATE) AS MAX_PERIOD_START_DATE
  ,MIN(REFERRAL_ASSESSMENT_DATE_1) AS MIN_REFERRAL_ASSESSMENT_DATE_1
  ,MAX(REFERRAL_ASSESSMENT_DATE_1) AS MAX_REFERRAL_ASSESSMENT_DATE_1
  ,MIN(REFERRAL_ASSESSMENT_DATE_2) AS MIN_REFERRAL_ASSESSMENT_DATE_2
  ,MAX(REFERRAL_ASSESSMENT_DATE_2) AS MAX_REFERRAL_ASSESSMENT_DATE_2
  ,MIN(REFERRAL_ASSESSMENT_DATE_3) AS MIN_REFERRAL_ASSESSMENT_DATE_3
  ,MAX(REFERRAL_ASSESSMENT_DATE_3) AS MAX_REFERRAL_ASSESSMENT_DATE_3
  ,MIN(REFERRAL_ASSESSMENT_DATE_4) AS MIN_REFERRAL_ASSESSMENT_DATE_4
  ,MAX(REFERRAL_ASSESSMENT_DATE_4) AS MAX_REFERRAL_ASSESSMENT_DATE_4
  ,MIN(SEEN_DATE) AS MIN_SEEN_DATE
  ,MAX(SEEN_DATE) AS MAX_SEEN_DATE
  ,MIN(SERVICE_REQUEST_DATE_1) AS MIN_SERVICE_REQUEST_DATE_1
  ,MAX(SERVICE_REQUEST_DATE_1) AS MAX_SERVICE_REQUEST_DATE_1
  ,MIN(SERVICE_REQUEST_DATE_2) AS MIN_SERVICE_REQUEST_DATE_2
  ,MAX(SERVICE_REQUEST_DATE_2) AS MAX_SERVICE_REQUEST_DATE_2
  ,MIN(SERVICE_REQUEST_DATE_3) AS MIN_SERVICE_REQUEST_DATE_3
  ,MAX(SERVICE_REQUEST_DATE_3) AS MAX_SERVICE_REQUEST_DATE_3
  ,MIN(SERVICE_REQUEST_DATE_4) AS MIN_SERVICE_REQUEST_DATE_4
  ,MAX(SERVICE_REQUEST_DATE_4) AS MAX_SERVICE_REQUEST_DATE_4
  ,MIN(START_DATE_1) AS MIN_START_DATE_1
  ,MAX(START_DATE_1) AS MAX_START_DATE_1
  ,MIN(START_DATE_2) AS MIN_START_DATE_2
  ,MAX(START_DATE_2) AS MAX_START_DATE_2
  ,MIN(START_DATE_3) AS MIN_START_DATE_3
  ,MAX(START_DATE_3) AS MAX_START_DATE_3
  ,MIN(START_DATE_4) AS MIN_START_DATE_4
  ,MAX(START_DATE_4) AS MAX_START_DATE_4
  ,MIN(TREATMENT_DATE_1) AS MIN_TREATMENT_DATE_1
  ,MAX(TREATMENT_DATE_1) AS MAX_TREATMENT_DATE_1
  ,MIN(TREATMENT_DATE_10) AS MIN_TREATMENT_DATE_10
  ,MAX(TREATMENT_DATE_10) AS MAX_TREATMENT_DATE_10
  ,MIN(TREATMENT_DATE_11) AS MIN_TREATMENT_DATE_11
  ,MAX(TREATMENT_DATE_11) AS MAX_TREATMENT_DATE_11
  ,MIN(TREATMENT_DATE_12) AS MIN_TREATMENT_DATE_12
  ,MAX(TREATMENT_DATE_12) AS MAX_TREATMENT_DATE_12
  ,MIN(TREATMENT_DATE_2) AS MIN_TREATMENT_DATE_2
  ,MAX(TREATMENT_DATE_2) AS MAX_TREATMENT_DATE_2
  ,MIN(TREATMENT_DATE_3) AS MIN_TREATMENT_DATE_3
  ,MAX(TREATMENT_DATE_3) AS MAX_TREATMENT_DATE_3
  ,MIN(TREATMENT_DATE_4) AS MIN_TREATMENT_DATE_4
  ,MAX(TREATMENT_DATE_4) AS MAX_TREATMENT_DATE_4
  ,MIN(TREATMENT_DATE_5) AS MIN_TREATMENT_DATE_5
  ,MAX(TREATMENT_DATE_5) AS MAX_TREATMENT_DATE_5
  ,MIN(TREATMENT_DATE_6) AS MIN_TREATMENT_DATE_6
  ,MAX(TREATMENT_DATE_6) AS MAX_TREATMENT_DATE_6
  ,MIN(TREATMENT_DATE_7) AS MIN_TREATMENT_DATE_7
  ,MAX(TREATMENT_DATE_7) AS MAX_TREATMENT_DATE_7
  ,MIN(TREATMENT_DATE_8) AS MIN_TREATMENT_DATE_8
  ,MAX(TREATMENT_DATE_8) AS MAX_TREATMENT_DATE_8
  ,MIN(TREATMENT_DATE_9) AS MIN_TREATMENT_DATE_9
  ,MAX(TREATMENT_DATE_9) AS MAX_TREATMENT_DATE_9
FROM read_csv_auto('FILE*.txt', delim = '|', all_varchar=true)
