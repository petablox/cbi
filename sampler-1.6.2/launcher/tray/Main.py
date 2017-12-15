import pygtk
pygtk.require('2.0')

import gconf
import gnome
import gtk

from GConfDir import GConfDir
from TrayIcon import TrayIcon

import Keys
import SamplerConfig
import Service

__pychecker__ = 'no-import'


########################################################################


def main():
    __pychecker__ = 'unusednames=tray'

    gnome.program_init('tray', SamplerConfig.version)
    unique = Service.unique()
    if not unique: return

    client = gconf.client_get_default()
    gconf_dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_ONELEVEL)

    tray = TrayIcon(client)
    gtk.main()

    del gconf_dir
