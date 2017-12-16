EXTRA_DIST =

include $(top_srcdir)/ocaml.mk.in

libdirs += $(dir $(libcommon))

all-local: graphlib.$(cma)

graphlib = $(graph) $(transitive)

graphlib.$(cma): $(graphlib)
	$(archive)

$(dir $(libcommon))%.cmi: $(libcommon); @:

$(libcommon): $(force)
	$(recurse)
