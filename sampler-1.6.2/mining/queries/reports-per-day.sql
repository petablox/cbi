-- number of new reports per day, suitable for histogram plotting

SELECT date(date) as bucket, count(*)
FROM run
GROUP BY bucket
ORDER BY bucket;
