class GConfDir(object):

    __slots__ = ['__client', '__id']

    def __init__(self, client, namespace, preload):
        self.__client = client
        self.__id = client.add_dir(namespace, preload)

    def __del__(self):
        if self.__id != None:
            self.__client.remove_dir(self.__id)
            self.__id = None
