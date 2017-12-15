SUBDIRS =					\
	common					\
	first-time				\
	pixmaps					\
	preferences				\
	tray					\
	wrapper

schema_DATA = sampler.schemas

noinst_SCRIPTS = test-by-extension

EXTRA_DIST =					\
	$(pkgdata_DATA)				\
	$(pkgdata_SCRIPTS)			\
	$(schema_DATA)

TESTS = $(schema_DATA)
TESTS_ENVIRONMENT = ./test-by-extension

install-data-hook:
if GCONF_SCHEMAS_INSTALL
	GCONF_CONFIG_SOURCE=$(GCONF_SCHEMA_CONFIG_SOURCE) gconftool-2 --makefile-install-rule $(schemadir)/$(schema_DATA) >/dev/null
endif
