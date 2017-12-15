SUBDIRS = graphlib

tools_SCRIPTS = resolve-cfg order-sites

EXTRA_DIST =

include $(top_srcdir)/ocaml.mk.in

MOSTLYCLEANFILES += $(tools_SCRIPTS)

libgraph = graphlib/graphlib.$(cma)

includes += -pp $(CAMLP4O)
libdirs += $(dir $(libcommon) $(libgraph))
syslibs = unix.$(cma)


resolve-cfg: $(libcommon) $(libgraph) $(resolve-cfg)
	$(link)

order-sites: $(libcommon) $(libgraph) $(order-sites)
	$(link)

$(dir $(libcommon))/%.cmi: $(libcommon); @:

$(dir $(libgraph))/%.cmi: $(libgraph); @:

$(libcommon) $(libgraph): $(force)
	$(recurse)

cfg := /usr/lib/sampler/sites/usr/lib/sampler/wrapped/usr/bin/evolution.cfg
sites := evolution-sites.txt

sampler_cc := $(top_builddir)/instrumentor/driver/sampler-cc-here

test: order-sites $(cfg)
	./$^ <$(sites)

MOSTLYCLEANFILES += *.cfg

$(sampler_cc): force
	$(MAKE) -C $(@D) $(@F)

.DELETE_ON_ERROR:
