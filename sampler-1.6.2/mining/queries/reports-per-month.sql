-- number of new reports per month, suitable for histogram plotting

SELECT extract(year from date) as year, extract(month from date) as month, count(*) as count
FROM run
GROUP BY year, month
ORDER BY year, month;
