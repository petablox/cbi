AM_CPPFLAGS = -W -Wall -Werror

noinst_PROGRAMS = modernize
modernize_SOURCES = modernize.l

EXTRA_DIST = stamps.pl

-include stamps.mk

overview.xml: $(stamps)
	find results/*/*/preds.txt -size +0 | ./overview.pl >$@
	xmllint --valid --noout $@

stamps: $(stamps)
.PHONY: stamps

stamps.mk: stamps.pl stamps.sql $(top_builddir)/config.status
if ENABLE_MINING
	./$< >$@
else
	touch $@
endif

CLEANFILES = stamps.mk
clean-local:
	rm -f overview.xml
	rm -rf results

.DELETE_ON_ERROR:
