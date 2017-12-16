services_DATA = edu.wisc.cs.cbi.FirstTime.service

first_time_DATA = first-time.glade

nodist_first_time_PYTHON = Paths.py
first_time_PYTHON =				\
	FirstTime.py				\
	Main.py					\
	Service.py				\
	StatusIcon.py

all_python = $(nodist_first_time_PYTHON) $(first_time_PYTHON)
link_python = GConfDir.py Keys.py SamplerConfig.py

first_time_SCRIPTS = first-time

EXTRA_DIST =					\
	$(first_time_DATA)			\
	$(first_time_PYTHON)			\
	$(services_DATA:=.in)			\
	Paths.py.in				\
	first-time.gladep			\
	first-time.in

BUILT_SOURCES =					\
	Paths.py				\
	edu.wisc.cs.cbi.FirstTime.service	\
	first-time

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(all_python) $(first_time_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(first_timedir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(first_timedir)/%.pyc)


dist-hook:
	cp -pd $(link_python) $(distdir)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''first_timedir@!$(first_timedir)!'	\
		-e 's!@''commondir@!$(commondir)!'		\
		<$< >$@
	chmod a+x $@


.DELETE_ON_ERROR:
