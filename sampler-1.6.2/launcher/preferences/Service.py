import dbus.service


class Server(dbus.service.Object):

    __slots__ = ['dialog']

    def __init__(self, bus_name):
        from PreferencesDialog import PreferencesDialog
        dbus.service.Object.__init__(self, bus_name=bus_name, object_path='/edu/wisc/cs/cbi/Preferences')
        self.dialog = PreferencesDialog()

    @dbus.service.method(dbus_interface='edu.wisc.cs.cbi.Preferences', in_signature='', out_signature='')
    def present(self):
        self.dialog.present()


def unique():
    from dbus.mainloop.glib import DBusGMainLoop
    DBusGMainLoop(set_as_default=True)

    bus = dbus.SessionBus()
    try:
        bus_name = dbus.service.BusName('edu.wisc.cs.cbi.Preferences', bus=bus, do_not_queue=True)
    except dbus.exceptions.NameExistsException:
        return None

    return Server(bus_name)
