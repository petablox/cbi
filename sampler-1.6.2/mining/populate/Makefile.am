EXTRA_DIST =					\
	Common.pm				\
	common.py				\
	freshen-builds				\
	freshen-runs

noinst_PYTHON =					\
	common.py				\
	insertBuilds.py				\
	insertRuns.py				\
	integrityChecks.py

if ENABLE_MINING
TESTS = $(noinst_PYTHON)
TESTS_ENVIRONMENT = pychecker --quiet --stdlib
endif
