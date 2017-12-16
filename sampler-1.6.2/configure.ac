m4_define(SAM_VERSION, m4_translit(m4_include([version]), [
]))

AC_INIT([sampler], SAM_VERSION, [liblit@cs.wisc.edu])
AC_CONFIG_AUX_DIR(config-aux)
AM_INIT_AUTOMAKE

if test -d $srcdir/papers; then
  AC_CONFIG_SUBDIRS(papers)
fi


########################################################################
#
#  Site-specific defaults
#


AC_MSG_CHECKING(for domain defaults)

domain="`dnsdomainname`"
case "$domain" in
  (cs.wisc.edu)
    : ${with_objcopy:=/afs/cs.wisc.edu/s/binutils-2.16.1/bin/objcopy}
    : ${PYTHON:=/s/python-2.4.3/bin/python}
  ;;
esac

AC_MSG_RESULT($domain)


########################################################################
#
#  Deployment-specific defaults
#


AC_MSG_CHECKING(for deployment site)
AC_ARG_ENABLE(deployment, AC_HELP_STRING([--enable-deployment=SITE], [Use settings for deployment at SITE]), , enable_deployment=default)
AC_MSG_RESULT($enable_deployment)

source deployments/$enable_deployment
if test "$enable_deployment" != default; then
  source deployments/$enable_deployment
fi

AC_SUBST(deployment_learn_more_url, $deployment_learn_more_url)
AC_SUBST(deployment_release_suffix, $deployment_release_suffix)
AC_SUBST(enable_deployment, $enable_deployment)


########################################################################
#
#  Linux distribution
#

AC_MSG_CHECKING(for distribution)

DISTRO_NAME="`lsb_release -is 2>/dev/null | tr A-Z a-z`"
DISTRO_VERSION="`lsb_release -rs`"

case "$DISTRO_NAME" in
  (fedoracore)
    DISTRO_NAME=fedora
    DISTRO_BASIS=rpm
    ;;
  (redhatenterpriseserver)
    DISTRO_NAME=rhel
    DISTRO_BASIS=rpm
    ;;
  (redhat|tao|centos|fedora)
    DISTRO_BASIS=rpm
    ;;
  (ubuntu)
    DISTRO_BASIS=debian
    ;;
esac

case "$DISTRO_BASIS" in
  (rpm)
    DISTRO_ARCH="`rpm --eval %_build_arch`"
    ;;
  (debian)
    DISTRO_ARCH="`dpkg-architecture -s -qDEB_BUILD_ARCH`"
    ;;
esac

: ${DISTRO_NAME:=unknown}
: ${DISTRO_VERSION:=unknown}
: ${DISTRO_ARCH:=unknown}
: ${DISTRO_BASIS:=unknown}

AC_SUBST(DISTRO_NAME)
AC_SUBST(DISTRO_VERSION)
AC_SUBST(DISTRO_ARCH)

AM_CONDITIONAL(DISTRO_BASIS_RPM, test "$DISTRO_BASIS" = rpm)
AM_CONDITIONAL(DISTRO_BASIS_DEBIAN, test "$DISTRO_BASIS" = debian)

AC_MSG_RESULT($DISTRO_NAME-$DISTRO_VERSION-$DISTRO_ARCH ($DISTRO_BASIS-based))


########################################################################
#
#  Basic C configuration
#

AC_PROG_CC
AM_PROG_LEX
AC_PROG_LIBTOOL
AC_PROG_LN_S


########################################################################
#
#  GNOME, GTK+, and Python configuration
#


AM_PATH_PYTHON

AC_ARG_WITH(gnome, AC_HELP_STRING([--without-gnome], [do not build GNOME-based GUI tools]), , with_gnome=yes)
AM_PATH_GLIB_2_0(, , with_gnome=no, gobject)
AM_CONDITIONAL(WITH_GNOME, test "$with_gnome" = yes)

AM_GCONF_SOURCE_2

PKG_PROG_PKG_CONFIG
AC_MSG_CHECKING(for D-Bus session services subdirectory)
AC_SUBST(servicesdir, `$PKG_CONFIG --variable=session_bus_services_dir dbus-1`)
AC_MSG_RESULT($servicesdir)
if test -z "$servicesdir"; then
  AC_MSG_WARN(cannot find D-Bus session services subdirectory)
fi


########################################################################
#
#  XML configuration
#


AC_CHECK_PROG(sk_config, scrollkeeper-config, scrollkeeper-config)
if test "$sk_config" != scrollkeeper-config; then
  AC_MSG_ERROR(cannot find scrollkeeper-config in $\PATH)
fi


AC_CHECK_PROG(XMLLINT, xmllint, xmllint, \${top_srcdir}/tools/skip-test)
if test "$XMLLINT" != xmllint; then
  AC_MSG_WARN(cannot find xmllint in \$PATH)
  AC_MSG_WARN(XML validation tests will be skipped)
fi


########################################################################
#
#  Sampler internal configuration
#


AC_SUBST(schemadir, '${GCONF_SCHEMA_FILE_DIR}')

AC_SUBST(pkglibdir, '${libdir}/${PACKAGE}')
AC_SUBST(driverdir, '${pkglibdir}/driver')
AC_SUBST(samplerdir, '${driverdir}/sampler')
AC_SUBST(schemesdir, '${samplerdir}/schemes')
AC_SUBST(threadsdir, '${samplerdir}/threads')
AC_SUBST(threads_yesdir, '${threadsdir}/yes')
AC_SUBST(threads_nodir, '${threadsdir}/no')
AC_SUBST(toolsdir, '${pkglibdir}/tools')
AC_SUBST(traylibdir, '${pkglibdir}/tray')

AC_SUBST(pkgdatadir, '${datadir}/${PACKAGE}')
AC_SUBST(commondir, '${pkgdatadir}/common')
AC_SUBST(first_timedir, '${pkgdatadir}/first-time')
AC_SUBST(launcherdir, '${pkgdatadir}/launcher')
AC_SUBST(pixmapsdir, '${pkgdatadir}/pixmaps')
AC_SUBST(preferencesdir, '${pkgdatadir}/preferences')
AC_SUBST(traydir, '${pkgdatadir}/tray')
AC_SUBST(wrapperdir, '${pkgdatadir}/wrapper')

AC_SUBST(wwwdir, '${localstatedir}/www')


AC_MSG_CHECKING(for mining support)
AC_ARG_ENABLE(mining, AC_HELP_STRING([--enable-mining], [Add rules for mining a local feedback database]), , enable_mining=no)
AM_CONDITIONAL(ENABLE_MINING, test "$enable_mining" = yes)
AC_MSG_RESULT($enable_mining)

AC_PATH_PROG(PERL, perl)


########################################################################
#
#  CIL configuration
#


AC_ARG_WITH(cil-sibling, AC_HELP_STRING([--without-cil-sibling], [do not look for CIL in sibling build tree]),
,
AC_MSG_CHECKING(for CIL in sibling build tree)
if test -d ../cil; then
  with_cil_sibling=yes
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi
)

if test "$with_cil_sibling" = yes; then
  cil_absolute=`cd ../cil; pwd`
  cil_libdir=$cil_absolute/obj/x86_LINUX

elif test -z "$cil_libdir"; then
  for cil_prefix in /usr/local/lib/ocaml /usr/local/lib /usr/lib/ocaml /usr/lib; do
    AC_MSG_CHECKING(for CIL in $cil_prefix)
    if test -d $cil_prefix/cil; then
      cil_libdir=$cil_prefix/cil
      AC_MSG_RESULT(yes)
      break
    else
      AC_MSG_RESULT(no)
    fi
  done
fi

if test -z "$cil_libdir"; then
  AC_MSG_ERROR(cannot find CIL)
fi

AC_SUBST(cil_libdir)


########################################################################
#
#  OCaml configuration
#


AC_CHECK_PROGS(OCAMLOPT, ocamlopt.opt ocamlopt)
if test -z "$OCAMLOPT"; then
  AC_MSG_ERROR(cannot find OCaml native compiler; please set \$OCAMLOPT)
fi

AC_CHECK_PROGS(OCAMLC, ocamlc.opt ocamlc)
if test -z "$OCAMLC"; then
  AC_MSG_ERROR(cannot find OCaml bytecode compiler; please set \$OCAMLC)
fi

AC_CHECK_PROGS(CAMLP4O, camlp4o.opt camlp4o)
if test -z "$CAMLP4O"; then
  AC_MSG_ERROR(cannot find OCaml pre-processor pretty-printer; plase set \$CAMLP4O)
fi


AC_MSG_CHECKING(whether $OCAMLC supports -dtypes)
if $OCAMLC -help 2>&1 | grep -q dtypes; then
  DTYPES=-dtypes
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST(DTYPES)


AC_MSG_CHECKING(for profiling)
AC_ARG_ENABLE(profiling, AC_HELP_STRING([--enable-profiling], [Compile OCaml for gprof profiling (implies --enable-native)]), , enable_profiling=no)
AM_CONDITIONAL(ENABLE_PROFILING, test "$enable_profiling" = yes)
AC_MSG_RESULT($enable_profiling)
if test "$enable_profiling" = yes; then
  enable_native=yes
fi


AC_MSG_CHECKING(for native compilation)
AC_ARG_ENABLE(native, AC_HELP_STRING([--disable-native], [Compile OCaml to bytecode (default: compile to native code)]), , enable_native=yes)
AM_CONDITIONAL(ENABLE_NATIVE, test "$enable_native" = yes)
AC_MSG_RESULT($enable_native)


########################################################################
#
#  Advanced C configuration
#


gcc=$CC
AC_MAKE_ABSOLUTE(gcc)

AC_MSG_CHECKING(for cpp0)
AC_SUBST(cpp0, `$CC -print-prog-name=cpp0`)
AC_MSG_RESULT($cpp0)
AC_MAKE_ABSOLUTE(cpp0, [])

AC_MSG_CHECKING(for cc1)
AC_SUBST(cc1, `$CC -print-prog-name=cc1`)
AC_MSG_RESULT($cc1)
AC_MAKE_ABSOLUTE(cc1)

AC_MSG_CHECKING(for as)
AC_SUBST(asm, `$CC -print-prog-name=as`)
AC_MSG_RESULT($asm)
AC_MAKE_ABSOLUTE(asm)

AC_MSG_CHECKING(for objcopy)
AC_ARG_WITH(objcopy, AC_HELP_STRING([--with-objcopy=EXE], [use EXE as objcopy (default: search in $PATH)]), ,
  with_objcopy=objcopy)
AC_SUBST(objcopy, $with_objcopy)
AC_MSG_RESULT($objcopy)
AC_MAKE_ABSOLUTE(objcopy)


AC_MSG_CHECKING(for thread-local support in compiler)
AC_COMPILE_IFELSE(
  AC_LANG_PROGRAM([extern __thread int global;], [global = 0; return 0;]),
  have_thread_storage=yes
  cp conftest.o conftest-tls.o,
  have_thread_storage=no)
AC_MSG_RESULT($have_thread_storage)

if test "$have_thread_storage" != no; then
  AC_MSG_CHECKING(for thread-local support in objcopy)
  $objcopy conftest-tls.o
  if ! nm -f sysv conftest-tls.o | egrep -q '^global .* TLS\|'; then
    have_thread_storage=no
  fi
  rm -f conftest-tls.o
  AC_MSG_RESULT($have_thread_storage)
fi

if test "$have_thread_storage" != no; then
  AC_MSG_CHECKING(for thread-local support at runtime)
  AC_RUN_IFELSE(
    AC_LANG_PROGRAM([__thread int global;], [global = 0; return 0;]),
    have_thread_storage=yes,
    have_thread_storage=no,
    have_thread_storage='optimistically assuming yes')
  AC_MSG_RESULT($have_thread_storage)
fi

if test "$have_thread_storage" = no; then
  AC_MSG_WARN(cannot instrument multithreaded applications)
else
  HAVE_THREAD_STORAGE=1
fi

AC_SUBST(HAVE_THREAD_STORAGE)
AM_CONDITIONAL(HAVE_THREAD_STORAGE, test "$have_thread_storage" != no)


AC_MSG_CHECKING(for log without -lm)
old_CFLAGS=$CFLAGS
CFLAGS="$CFLAGS -ffast-math"
AC_LINK_IFELSE(
  AC_LANG_PROGRAM([#include <math.h>], [log(1.)]),
  AC_MSG_RESULT(yes),
  AC_MSG_RESULT(no)
  AC_SUBST(LIBM, -lm))
CFLAGS=$old_CFLAGS


CPPFLAGS="$CPPFLAGS -D_FORTIFY_SOURCE=2"


AM_PATH_GSL


########################################################################
#
#  Output
#

AM_CONFIG_HEADER(config.h)

AC_CONFIG_TESTDIR(instrumentor/balance)
AC_CONFIG_TESTDIR(instrumentor/bounds)
AC_CONFIG_TESTDIR(instrumentor/branches)
AC_CONFIG_TESTDIR(instrumentor/function-entries)
AC_CONFIG_TESTDIR(instrumentor/g-object-unref)
AC_CONFIG_TESTDIR(instrumentor/nothing)
AC_CONFIG_TESTDIR(instrumentor/returns)
AC_CONFIG_TESTDIR(instrumentor/scalar-pairs)
AC_CONFIG_TESTDIR(instrumentor/timestamps)

AC_CONFIG_FILES([
Makefile
config.m4
debian/Makefile
doc/Makefile
doc/config.xml
doc/sampler-guide/Makefile
doc/sampler-guide/C/Makefile
driver/Makefile
fuzz/Makefile
instrumentor/Makefile
instrumentor/balance/Makefile
instrumentor/bounds/Makefile
instrumentor/branches/Makefile
instrumentor/function-entries/Makefile
instrumentor/g-object-unref/Makefile
instrumentor/g-object-unref/atlocal
instrumentor/nothing/Makefile
instrumentor/returns/Makefile
instrumentor/scalar-pairs/Makefile
instrumentor/timestamps/Makefile
instrumentor/version.ml
launcher/Makefile
launcher/common/Makefile
launcher/first-time/Makefile
launcher/first-time/first-time.glade
launcher/pixmaps/Makefile
launcher/preferences/Makefile
launcher/tray/Makefile
launcher/wrapper/Makefile
lib/Makefile
lib/schemes/Makefile
lib/threads/Makefile
lib/threads/no/Makefile
lib/threads/yes/Makefile
mining/analysis/Makefile
mining/dumps/Makefile
mining/Makefile
mining/populate/Makefile
mining/queries/Makefile
ocaml/Makefile
sampler.spec
tools/Makefile
tools/cfg/Makefile
tools/cfg/graphlib/Makefile
www/Makefile
www/cgi-bin/Makefile
])

AC_CONFIG_FILES([driver/sampler-cc], [chmod +x $ac_file])
AC_CONFIG_FILES([driver/sampler-cc-here], [chmod +x $ac_file])
AC_CONFIG_FILES([driver/as], [chmod +x $ac_file])
AC_CONFIG_FILES([driver/cc1], [chmod +x $ac_file])
AC_CONFIG_FILES([instrumentor/build-libraries], [chmod +x $ac_file])
AC_CONFIG_FILES([launcher/test-by-extension], [chmod +x $ac_file])
AC_CONFIG_FILES([mining/analysis/one], [chmod +x $ac_file])
AC_CONFIG_FILES([mining/analysis/stamps.pl], [chmod +x $ac_file])
AC_CONFIG_FILES([mining/populate/insertBuilds.py], [chmod +x $ac_file])
AC_CONFIG_FILES([mining/populate/insertRuns.py], [chmod +x $ac_file])
AC_CONFIG_FILES([mining/populate/integrityChecks.py], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/add-depends], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/build-info-deb], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/find-sampler-info], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/install-gconf], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/install-wrappers], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/rpmbuild], [chmod +x $ac_file])

AC_OUTPUT
