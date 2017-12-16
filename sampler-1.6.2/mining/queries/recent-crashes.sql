-- failed runs by date, most recent first

SELECT application_name, application_version, application_release, date
FROM run NATURAL JOIN build
WHERE exit_signal != 0
ORDER BY date DESC;
