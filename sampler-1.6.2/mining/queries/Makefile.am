query_sql :=					\
	nautilus.sql				\
	outcome-summary.sql			\
	outcome-summary-per-version.sql		\
	popular-apps.sql			\
	popular-builds.sql			\
	popular-crashing-builds.sql		\
	recent-crashes.sql			\
	reports-per-day-app.sql			\
	reports-per-day.sql			\
	reports-per-month.sql			\
	reports-per-month-app.sql		\
	reports-per-month-distro.sql		\
	reports-per-month-server.sql		\
	reports-per-week-app.sql		\
	reports-per-week.sql

query_out := $(query_sql:.sql=.out)

EXTRA_DIST =					\
	$(query_sql)				\
	run-query				\
	untabbify

answers: $(query_out)
.PHONY: answers

$(query_out): %.out: run-query %.sql ../populate/sync-stamp
	./$< $*.sql >$@

.DELETE_ON_ERROR:
