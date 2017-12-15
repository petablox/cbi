import urlparse


########################################################################
#
#  GUI callbacks and helpers for server-message dialog
#


class ServerMessage(object):

    __slots__ = ['__dialog', '__document']

    def __init__(self, base, content_type, body):
        import cgi
        import gnome
        import gtk.glade
        import gtkhtml2
        import sys
        import BlipIcons
        import SamplerConfig
        import Paths
        import Signals

        argv = sys.argv
        sys.argv = [sys.argv[0]]
        gnome.program_init('wrapper', SamplerConfig.version)
        sys.argv = argv

        xml = gtk.glade.XML(Paths.glade)
        Signals.autoconnect(self, xml)
        self.__dialog = xml.get_widget('server-message')
        pixmap = self.__dialog.render_icon(BlipIcons.stock[True],
                                           BlipIcons.ICON_SIZE_EMBLEM, '')
        self.__dialog.set_icon(pixmap)

        document = gtkhtml2.Document()
        document.connect('request_url', self.on_request_url)
        document.connect('set_base', self.on_set_base)
        document.connect('link_clicked', self.on_link_clicked)
        document.connect('title_changed', self.on_title_changed)
        document.dialog = self.__dialog
        document.base = ''
        self.on_set_base(document, base)
        [mime_type, options] = cgi.parse_header(content_type)
        document.open_stream(mime_type)
        document.write_stream(body)
        document.close_stream()
        self.__document = document

        view = gtkhtml2.View()
        view.set_document(document)
        port = xml.get_widget('html-scroll')
        port.add(view)
        view.show()

    def run(self):
        result = self.__dialog.run()
        # GNOME bugzilla bug 119496
        self.__document.clear()
        self.__dialog.destroy()
        return result

    def on_request_url(self, document, url, stream):
        import urllib2
        full = urlparse.urljoin(document.base, url)
        reply = urllib2.urlopen(full)
        stream.write(reply.read())
        stream.close()

    def on_set_base(self, document, base):
        document.base = urlparse.urljoin(document.base, base)

    def on_link_clicked(self, document, link):
        import gnome
        full = urlparse.urljoin(document.base, link)
        gnome.url_show(full)

    def on_title_changed(self, document, title):
        document.dialog.set_title(title)
