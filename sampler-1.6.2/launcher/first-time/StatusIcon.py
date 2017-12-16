class StatusIcon(object):

    __slots__ = ['__notifier', '__size', '__widget']

    def __init__(self, client, widget, size):
        from MasterNotifier import MasterNotifier
        self.__widget = widget
        self.__size = size
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        import BlipIcons
        self.__widget.set_from_stock(BlipIcons.stock[enabled], self.__size)
