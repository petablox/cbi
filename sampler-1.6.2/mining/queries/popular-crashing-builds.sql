-- find builds with the most crashes

SELECT build_distribution, application_name, application_version, application_release, build_date, count(*) as reports, sum(case when exit_signal = 0 then 0 else 1 end) as crashes
FROM run NATURAL JOIN build
GROUP BY build_id, build_distribution, application_name, application_version, application_release, build_date
ORDER BY crashes DESC;
