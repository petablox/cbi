-- number of new reports per week, suitable for histogram plotting

SELECT extract(year from date) as year, extract(month from date) as month, server_name, count(*) as count
FROM run
GROUP BY year, month, server_name
ORDER BY year, month, server_name;
