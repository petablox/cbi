nodist_common_PYTHON = SamplerConfig.py
common_PYTHON =					\
	BlipIcons.py				\
	GConfDir.py				\
	GConfNotifier.py			\
	Keys.py					\
	MasterNotifier.py			\
	Signals.py				\
	WindowIcon.py

all_python = $(nodist_common_PYTHON) $(common_PYTHON)

EXTRA_DIST = $(common_PYTHON) SamplerConfig.py.in

BUILT_SOURCES = SamplerConfig.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(all_python)
TESTS_ENVIRONMENT = ../test-by-extension

install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(commondir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(commondir)/%.pyc)


SamplerConfig.py: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''pixmapsdir@!$(pixmapsdir)!'		\
		<$< >$@


.DELETE_ON_ERROR:
