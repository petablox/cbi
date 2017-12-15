class Application(object):

    __slots__ = ['__client', '__iter', '__notify', '__root', 'name']

    def __init__(self, client, model, path):
        self.__root = path
        self.name = path.split('/')[-1]

        from GConfNotifier import GConfNotifier
        self.__client = client
        self.__notify = GConfNotifier(client, self.__key('enabled'), self.__gconf_notify, model)

        self.__iter = model.add_application(self)

    def __gconf_notify(self, client, connection, entry, model):
        __pychecker__ = 'no-argsused'
        model.row_changed(model.get_path(self.__iter), self.__iter)

    def __key(self, item):
        return self.__root + '/' + item

    def get_enabled(self):
        return self.__client.get_bool(self.__key('enabled'))

    def set_enabled(self, value):
        self.__client.set_bool(self.__key('enabled'), value)
