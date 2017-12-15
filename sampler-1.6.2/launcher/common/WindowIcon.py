class WindowIcon(object):

    __slots__ = ['__notify', '__widget']

    def __init__(self, client, widget):
        from MasterNotifier import MasterNotifier
        self.__widget = widget
        self.__notify = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        import BlipIcons
        pixbuf = self.__widget.render_icon(BlipIcons.stock[enabled], BlipIcons.ICON_SIZE_EMBLEM, "")
        self.__widget.set_icon(pixbuf)
