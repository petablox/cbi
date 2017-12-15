-- number of new reports per week, suitable for histogram plotting

SELECT extract(year from date) as year, extract(month from date) as month, build_distribution, count(*) as count
FROM run
NATURAL JOIN build
GROUP BY year, month, build_distribution
ORDER BY year, month, build_distribution;
