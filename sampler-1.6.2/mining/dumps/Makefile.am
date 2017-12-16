EXTRA_DIST =					\
	schema.sql


all-local: schema.sql

schema.sql:
	pg_dump --clean --schema-only --no-owner --no-privileges --file=$@.
	sed -e '/^COMMENT ON SCHEMA public IS /s/^/-- /' <$@. >$@
	rm $@.

complete.pg: ../populate/sync-stamp
	pg_dump --format=c --file=$@.tmp
	mv $@.tmp $@

.DELETE_ON_ERROR:
