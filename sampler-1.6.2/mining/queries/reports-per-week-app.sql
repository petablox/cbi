-- number of new reports per week, suitable for histogram plotting

SELECT extract(year from date) as year, floor(extract(doy from date) / 7) as week, application_name, count(*) as count
FROM run
NATURAL JOIN build
GROUP BY year, week, application_name
ORDER BY year, week, application_name;
