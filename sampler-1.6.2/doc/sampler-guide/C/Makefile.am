#figdir = figures
docname = sampler-guide
lang = C
omffile = $(docname)-$(lang).omf
entities =

include $(top_srcdir)/doc/xmldocs.make
xml_files += $(docname).xsl $(docname).css

clean_omf = *.omf.out omf_timestamp
clean_html = index.html ar??s??.html
MOSTLYCLEANFILES = $(clean_omf) $(clean_html)

install-data-hook-omf: install-data-hook-config

install-data-hook-config:
	$(MAKE) -C ../.. install-docDATA

dist-hook: app-dist-hook


TESTS = $(docname).xml $(omffile)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


html-local: index.html

index.html: $(docname).xml $(docname).xsl
	rm -f $(clean_html)
	xsltproc $<

.DELETE_ON_ERROR:
