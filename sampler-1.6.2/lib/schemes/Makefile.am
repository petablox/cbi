AM_CFLAGS = -W -Wall -Werror -Wformat=2 -fpic
INCLUDES = @GLIB_CFLAGS@


if WITH_GNOME
gnome_headers =					\
	g-object-unref.h			\
	g-object-unref-unit.h

gnome_libraries = libsampler-g-object-unref.la
endif


schemes_HEADERS =				\
	$(gnome_headers)			\
	bounds.h				\
	bounds-unit.h				\
	branches.h				\
	branches-unit.h				\
	float-kinds.h				\
	float-kinds-unit.h			\
	function-entries.h			\
	function-entries-unit.h			\
	returns.h				\
	returns-unit.h				\
	scalar-pairs.h				\
	scalar-pairs-unit.h			\
	tuple-1.h				\
	tuple-2.h				\
	tuple-3.h				\
	tuple-4.h				\
	tuple-9.h

lib_LTLIBRARIES =				\
	libsampler-schemes.la			\
	$(gnome_libraries)			\
	libsampler-bounds.la			\
	libsampler-branches.la			\
	libsampler-float-kinds.la		\
	libsampler-function-entries.la		\
	libsampler-returns.la			\
	libsampler-scalar-pairs.la

if WITH_GNOME
libsampler_g_object_unref_la_SOURCES = g-object-unref.c g-object-unref-classify.c
libsampler_g_object_unref_la_LIBADD = libsampler-schemes.la $(GLIB_LIBS)
endif

libsampler_bounds_la_SOURCES = bounds.c bounds.h
libsampler_branches_la_SOURCES = branches.c branches.h
libsampler_float_kinds_la_SOURCES = float-kinds.c float-kinds.h
libsampler_function_entries_la_SOURCES = function-entries.c function-entries.h
libsampler_returns_la_SOURCES = returns.c returns.h
libsampler_scalar_pairs_la_SOURCES = scalar-pairs.c scalar-pairs.h

libsampler_bounds_la_LIBADD = libsampler-schemes.la
libsampler_branches_la_LIBADD = libsampler-schemes.la
libsampler_float_kinds_la_LIBADD = libsampler-schemes.la -lm
libsampler_function_entries_la_LIBADD = libsampler-schemes.la
libsampler_returns_la_LIBADD = libsampler-schemes.la
libsampler_scalar_pairs_la_LIBADD = libsampler-schemes.la

libsampler_schemes_la_SOURCES =			\
	samples.c				\
	samples.h				\
	timestamps.c				\
	tuple-1.c				\
	tuple-1.h				\
	tuple-2.c				\
	tuple-2.h				\
	tuple-3.c				\
	tuple-3.h				\
	tuple-4.c				\
	tuple-4.h				\
	tuple-9.c				\
	tuple-9.h
