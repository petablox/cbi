AUTOMAKE_OPTIONS = foreign 1.6
ACLOCAL_AMFLAGS = -I /usr/share/aclocal

am__tar = ${AMTAR} cof - "$$tardir"

if DISTRO_BASIS_DEBIAN
debian = debian
endif

SUBDIRS =					\
	$(debian)				\
	doc					\
	driver					\
	fuzz					\
	instrumentor				\
	launcher				\
	lib					\
	mining					\
	ocaml					\
	tools					\
	www

EXTRA_DIST = $(PACKAGE).spec deployments


all-local: $(srcdir)/package.m4

MOSTLYCLEANFILES = $(srcdir)/package.m4
$(srcdir)/package.m4: $(top_srcdir)/configure.ac
	{									\
	  echo '# Signature of the current package.';				\
	  echo 'm4_define([AT_PACKAGE_NAME],      [@PACKAGE_NAME@])';		\
	  echo 'm4_define([AT_PACKAGE_TARNAME],   [@PACKAGE_TARNAME@])';	\
	  echo 'm4_define([AT_PACKAGE_VERSION],   [@PACKAGE_VERSION@])';	\
	  echo 'm4_define([AT_PACKAGE_STRING],    [@PACKAGE_STRING@])';		\
	  echo 'm4_define([AT_PACKAGE_BUGREPORT], [@PACKAGE_BUGREPORT@])';	\
	} >$@

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(pkglibdir)/sites
	$(mkinstalldirs) $(DESTDIR)$(pkglibdir)/wrapped

rpms: $(PACKAGE).spec dist
	rm -rf redhat
	mkdir -p redhat/BUILD redhat/RPMS/$(DISTRO_ARCH) redhat/SOURCES redhat/SPECS redhat/SRPMS
	$(LN_S) ../../$(distdir).tar.gz redhat/SOURCES
	rpmbuild --define '_topdir $(shell pwd)/redhat' -ba $<

debs: dist
	rm -rf debuild
	mkdir debuild
	cp $(distdir).tar.gz debuild
	cd debuild && tar xzf $(distdir).tar.gz
	cd debuild/$(distdir) && debuild

dist-hook:
	rm -rf $(distdir)/deployments/.svn
