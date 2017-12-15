import gtk
import gtk.gdk
import gtk.glade

import BlipIcons
from MasterNotifier import MasterNotifier
import Paths
from PopupMenu import PopupMenu
import PreferencesDialog
import Signals


class TrayIcon(gtk.StatusIcon):

    __slots__ = ['__notifier']

    def on_activate(self):
        PreferencesDialog.present()

    def on_popup_menu(self, button, activate_time, popup):
        popup.popup(button, activate_time)

    def __init__(self, client):
        gtk.StatusIcon.__init__(self)
        popup = PopupMenu(client, self)
        self.connect('activate', TrayIcon.on_activate)
        self.connect('popup-menu', TrayIcon.on_popup_menu, popup)
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        self.set_from_stock(BlipIcons.stock[enabled])
        description = {True:  'enabled', False: 'disabled'}[enabled]
        self.set_tooltip('Automatic reporting is %s' % description)
