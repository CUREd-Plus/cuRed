SELECT DISTINCT YEAR(LEAST(seen_date, arrival_date)) AS ecds_year
FROM hes_ecds
ORDER BY 1;
