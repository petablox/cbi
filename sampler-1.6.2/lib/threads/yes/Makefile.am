AM_CPPFLAGS = -DCBI_THREADS
AM_CFLAGS = -ffast-math -fpic -pthread
AM_LDFLAGS = -Wl,--wrap,pthread_create -Wl,--wrap,fork

include ../threads.mk

threads_yes_HEADERS = $(headers)

lib_LTLIBRARIES =				\
	libsampler_r.la				\
	libsampler-fixed_r.la			\
	libsampler-offline_r.la			\
	libsampler-online_r.la

libsampler_fixed_r_la_SOURCES = ../random-fixed.c
libsampler_offline_r_la_SOURCES = ../random-offline.c
libsampler_online_r_la_SOURCES = ../random-online.c

libsampler_fixed_r_la_LIBADD = libsampler_r.la
libsampler_offline_r_la_LIBADD = libsampler_r.la
libsampler_online_r_la_LIBADD = libsampler_r.la

libsampler_r_la_SOURCES = $(common)
