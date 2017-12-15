EXTRA_DIST =					\
	find-implicits				\
	find-unused				\
	link-order

include $(top_srcdir)/ocaml.mk.in


all-local: common.$(cma)


common =					\
	$(fixpoint)				\
	$(hashClass)				\
	$(mapClass)				\
	$(queueClass)				\
	$(stringHash)				\
	$(stackClass)

common.$(cma): $(common)
	$(archive)
