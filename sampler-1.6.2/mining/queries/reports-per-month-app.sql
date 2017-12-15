-- number of new reports per week, suitable for histogram plotting

SELECT extract(year from date) as year, extract(month from date) as month, application_name, count(*) as count
FROM run
NATURAL JOIN build
GROUP BY year, month, application_name
ORDER BY year, month, application_name;
