import pygtk
pygtk.require('2.0')


########################################################################


import gtk

import Keys


########################################################################
#
#  GUI callbacks and helpers for first-time opt-in dialog
#


class FirstTime(object):

    __slots__ = ['__client', '__dialog', '__dir', '__icon_updater', '__image_updater', '__notifier', '__xml']

    def __get_widget(self, name):
        return self.__xml.get_widget(name)

    def __init__(self):
        import gtk.glade
        import Paths
        import Signals
        root = 'first-time'
        self.__xml = gtk.glade.XML(Paths.glade, root)
        self.__dialog = self.__get_widget(root)
        Signals.autoconnect(self, self.__xml)

        # hook up GConf configuration monitoring
        import gconf
        from GConfDir import GConfDir
        self.__client = gconf.client_get_default()
        self.__dir = GConfDir(self.__client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

        # hook up state-linked icons
        from StatusIcon import StatusIcon
        from WindowIcon import WindowIcon
        image = self.__get_widget('image')
        self.__image_updater = StatusIcon(self.__client, image, gtk.ICON_SIZE_DIALOG)
        self.__icon_updater = WindowIcon(self.__client, self.__dialog)

        # hook up state-linked radio buttons
        from MasterNotifier import MasterNotifier
        self.__notifier = MasterNotifier(self.__client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        self.__radio_refresh('yes', enabled)
        self.__radio_refresh('no', not enabled)

    def __radio_refresh(self, name, active):
        radio = self.__get_widget(name)
        details = self.__get_widget(name + '-details')
        radio.set_active(active)
        details.set_sensitive(active)

    def on_yes_toggled(self, yes):
        enabled = yes.get_active()
        self.__client.set_bool(Keys.master, enabled)

    def on_response(self, dialog, response):
        __pychecker__ = 'no-argsused'
        if response == gtk.RESPONSE_OK:
            self.__client.set_bool(Keys.asked, True)

    def present(self):
        return self.__dialog.present()

    def run(self):
        result = self.__dialog.run()
        self.__dialog.destroy()
        return result
