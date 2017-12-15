SUBDIRS =					\
	balance					\
	bounds					\
	branches				\
	function-entries			\
	g-object-unref				\
	nothing					\
	returns					\
	scalar-pairs				\
	timestamps

nodist_ml = libraries.ml version.ml
EXTRA_DIST = libraries.ml.in

targets = harness.$(cma)
extra_impls = libraries version

include $(top_srcdir)/ocaml.mk.in

libdirs += $(top_builddir)/ocaml
syslibs = str.$(cma) unix.$(cma)

driver_SCRIPTS = main


MOSTLYCLEANFILES += libraries.ml
libraries.ml: %: build-libraries %.in
	./$^ >$@

$(dir $(libcommon))%.cmi: $(libcommon); @:
$(dir $(libcommon))%.cmx: $(libcommon); @:
$(libcommon): $(force); $(recurse)

MOSTLYCLEANFILES += main
main: $(libcil) $(libcommon) $(main)
	$(link)

MOSTLYCLEANFILES += cfgTest
cfgTest: $(libcil) $(cfgTest)
	$(link)

MOSTLYCLEANFILES += cfg-to-dot
cfg-to-dot: $(libcil) $(cfg-to-dot)
	$(link)

MOSTLYCLEANFILES += checker
checker: $(libcil) $(checker)
	$(link)

MOSTLYCLEANFILES += dump
dump: $(libcil) $(dump)
	$(link)

MOSTLYCLEANFILES += loopless
loopless: $(libcil) $(loopless)
	$(link)

check-local: main

.DELETE_ON_ERROR:


########################################################################


floaty: floaty.c main
	../driver/sampler-cc-here -g -save-temps --no-sample --sampler-scheme=float-kinds -o floaty floaty.c
