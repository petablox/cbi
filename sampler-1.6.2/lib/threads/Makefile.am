if HAVE_THREAD_STORAGE
threads_yes = yes
endif

SUBDIRS = no $(threads_yes)


threads_HEADERS =				\
	countdown.h				\
	local.h					\
	random-fixed.h				\
	random-offline.h			\
	random-offline-size.h			\
	random-online.h

EXTRA_DIST =					\
	countdown.c				\
	initialize.c				\
	lifetime.h				\
	random.h				\
	random-fixed.c				\
	random-offline.c			\
	random-online.c				\
	registry.c				\
	report.c				\
	report.h				\
	threads.mk				\
	timestamps-set.c			\
	verbose.c				\
	verbose.h
