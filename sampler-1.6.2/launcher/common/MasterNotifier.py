from GConfNotifier import GConfNotifier
import Keys


class MasterNotifier(GConfNotifier):

    __slots__ = ['__callback', '__client']

    def __init__(self, client, callback):
        GConfNotifier.__init__(self, client, Keys.master, self.__changed)
        self.__client = client
        self.__callback = callback
        self.__changed()

    def __changed(self, *args):
        __pychecker__ = 'no-argsused'
        enabled = self.__client.get_bool(Keys.master)
        self.__callback(enabled)
