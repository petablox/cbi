-- outcome of each applcation's runs, ordered by crash frequency

SELECT
    *,
    crash / count::float as crash_rate
FROM (
    SELECT
	application_name,
	count(*) as count,
	sum(case when exit_status = 0 AND exit_signal = 0 then 1 else 0 end) AS good,
	sum(case when exit_status != 0 then 1 else 0 end) AS error,
	sum(case when exit_signal != 0 then 1 else 0 end) AS crash
    FROM run NATURAL JOIN build
    GROUP BY application_name
) AS subquery
ORDER BY crash_rate DESC
