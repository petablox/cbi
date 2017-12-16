import pygtk
pygtk.require('2.0')

import gnome

import SamplerConfig
import Service


########################################################################


def main():
    gnome.program_init('preferences', SamplerConfig.version)
    unique = Service.unique()

    if unique:
        unique.dialog.run()

    else:
        import dbus
        import gtk.gdk
        bus = dbus.SessionBus()
        remote = bus.get_object('edu.wisc.cs.cbi.Preferences', '/edu/wisc/cs/cbi/Preferences')
        iface = dbus.Interface(remote, 'edu.wisc.cs.cbi.Preferences')
        iface.present()
        gtk.gdk.notify_startup_complete()
