pixmaps_DATA = 					\
	disabled-48.png				\
	disabled-96.png				\
	enabled-48.png				\
	enabled-96.png

EXTRA_DIST =					\
	$(pixmaps_DATA)				\
	master-48.xcf				\
	master-96.xcf

install-data-local: install-icon-48 install-icon-96

install-icon-%: enabled-%.png
	$(mkdir_p) '$(DESTDIR)$(datadir)/icons/hicolor/$*x$*/apps'
	$(INSTALL_DATA) enabled-$*.png '$(DESTDIR)$(datadir)/icons/hicolor/$*x$*/apps/sampler.png'
