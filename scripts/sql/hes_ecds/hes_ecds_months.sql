SELECT DISTINCT strftime(least(SEEN_DATE, ARRIVAL_DATE), '%Y-%m') AS ecds_month
FROM hes_ecds
ORDER BY 1;
