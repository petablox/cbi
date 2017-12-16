-- number of new reports per day, suitable for histogram plotting

SELECT date(date) as bucket, application_name, count(*)
FROM run
NATURAL JOIN build
GROUP BY bucket, application_name
ORDER BY bucket, application_name;
