import pygtk
pygtk.require('2.0')

import gnome

import SamplerConfig
import Service


########################################################################


def main():
    gnome.program_init('tray', SamplerConfig.version)
    unique = Service.unique()

    if unique:
        unique.dialog.run()

    else:
        import dbus
        bus = dbus.SessionBus()
        remote = bus.get_object('edu.wisc.cs.cbi.FirstTime', '/edu/wisc/cs/cbi/FirstTime')
        iface = dbus.Interface(remote, 'edu.wisc.cs.cbi.FirstTime')
        iface.present()
