import gtk.glade

from MasterNotifier import MasterNotifier
from WindowIcon import WindowIcon
import Paths
import SamplerConfig
import Signals


class AboutDialog(object):

    __slots__ = ['__icon_updater', '__notifier', '__widget']

    def __init__(self, client):
        xml = gtk.glade.XML(Paths.glade, 'about')
        self.__widget = xml.get_widget('about')
        Signals.autoconnect(self, xml)

        self.__widget.set_property('name', 'Bug Isolation Monitor')
        self.__widget.set_property('version', SamplerConfig.version)
        self.__icon_updater = WindowIcon(client, self.__widget)
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        import BlipIcons
        widget = self.__widget
        pixbuf = widget.render_icon(BlipIcons.stock[enabled], BlipIcons.ICON_SIZE_EMBLEM, "")
        widget.set_property('logo', pixbuf)

    def present(self):
        self.__widget.present()

    def on_dialog_delete(self, dialog, event):
        return True

    def on_dialog_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return True
        else:
            return False
