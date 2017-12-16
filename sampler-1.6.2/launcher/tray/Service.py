from dbus.mainloop.glib import DBusGMainLoop

import dbus.service
import gtk


class Server(dbus.service.Object):

    __slots__ = ['__clients']

    def __init__(self, bus_name):
        dbus.service.Object.__init__(self, bus_name=bus_name, object_path='/edu/wisc/cs/cbi/Monitor')
        self.clients = set()

        broker = bus_name.get_bus().get_object('org.freedesktop.DBus', '/org/freedesktop/DBus')
        broker.connect_to_signal('NameOwnerChanged', self.__owner_changed, dbus_interface='org.freedesktop.DBus')

    @dbus.service.method(dbus_interface='edu.wisc.cs.cbi.Monitor', sender_keyword='sender', in_signature='', out_signature='')
    def activate(self, sender):
        assert sender.startswith(':')
        assert sender not in self.clients
        self.clients.add(sender)

    def __owner_changed(self, name, seller, buyer):
        if not buyer and name == seller and name.startswith(':'):
            self.clients.discard(name)
            if not self.clients:
                gtk.main_quit()


def unique():
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()

    try:
        bus_name = dbus.service.BusName('edu.wisc.cs.cbi.Monitor', bus=bus, do_not_queue=True)
    except dbus.exceptions.NameExistsException:
        return None

    return Server(bus_name)
