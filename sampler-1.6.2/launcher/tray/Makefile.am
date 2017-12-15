services_DATA = edu.wisc.cs.cbi.Monitor.service

tray_DATA = tray.glade

nodist_tray_PYTHON = Paths.py
tray_PYTHON =					\
	AboutDialog.py				\
	Main.py					\
	PopupMenu.py				\
	PreferencesDialog.py			\
	Service.py				\
	TrayIcon.py

all_python = $(nodist_tray_PYTHON) $(tray_PYTHON)

link_python =					\
	BlipIcons.py				\
	GConfDir.py				\
	GConfNotifier.py			\
	Keys.py					\
	MasterNotifier.py			\
	SamplerConfig.py			\
	Signals.py				\
	WindowIcon.py

tray_SCRIPTS = tray

EXTRA_DIST =					\
	$(services_DATA:=.in)			\
	$(tray_DATA)				\
	$(tray_PYTHON)				\
	Paths.py.in				\
	activate				\
	tray.gladep				\
	tray.in

BUILT_SOURCES =					\
	Paths.py				\
	edu.wisc.cs.cbi.Monitor.service		\
	tray

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(all_python) $(servers_DATA) $(tray_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(traydir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(traydir)/%.pyc)


dist-hook:
	cp -pd $(link_python) $(distdir)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''bindir@!$(bindir)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''traydir@!$(traydir)!'			\
		-e 's!@''traylibdir@!$(traylibdir)!'		\
		<$< >$@
	if [ -x $< ]; then chmod +x $@; fi


.DELETE_ON_ERROR:
