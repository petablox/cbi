EXTRA_DIST =					\
	late-global.c				\
	late-global.expected			\
	testsuite.at				\
	upcase-bad.c				\
	upcase-bad.expected			\
	upcase-good.c				\
	upcase-good.expected

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
