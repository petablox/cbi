EXTRA_DIST =					\
	test.c					\
	test.expected				\
	testsuite.at

TESTSUITE = $(srcdir)/testsuite
check_SCRIPTS = $(TESTSUITE)
check-local: atconfig $(TESTSUITE)
	$(SHELL) $(TESTSUITE)

atconfig: $(top_builddir)/config.status
	cd $(top_builddir) && $(SHELL) ./config.status $(subdir)/$@

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_builddir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@

CLEANFILES = atconfig
clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean
	rm -f $(TESTSUITE)

.DELETE_ON_ERROR:
