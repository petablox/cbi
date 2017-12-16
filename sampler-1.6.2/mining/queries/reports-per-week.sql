-- number of new reports per week, suitable for histogram plotting

SELECT extract(year from date) as year, floor(extract(doy from date) / 7) as week, count(*) as count
FROM run
GROUP BY year, week
ORDER BY year, week;
