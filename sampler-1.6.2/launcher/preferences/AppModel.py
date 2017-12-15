import pygtk
pygtk.require('2.0')


########################################################################


import gtk


class AppModel(gtk.ListStore):

    COLUMN_NAME = 0
    COLUMN_ENABLED = 1

    def add_application(self, app):
        iterator = self.append()
        self.set(iterator,
                 self.COLUMN_NAME, app,
                 self.COLUMN_ENABLED, app)
        return iterator

    def __sort_name(self, model, a, b):
        __pychecker__ = 'no-argsused'
        import locale
        a = self.get_value(a, self.COLUMN_NAME)
        b = self.get_value(b, self.COLUMN_NAME)
        return locale.strcoll(a.name, b.name)

    def __sort_enabled(self, model, a, b):
        __pychecker__ = 'no-argsused'
        a = self.get_value(a, self.COLUMN_ENABLED)
        b = self.get_value(b, self.COLUMN_ENABLED)
        return a.get_enabled() - b.get_enabled()

    def __init__(self):
        import gobject
        gtk.ListStore.__init__(self, gobject.TYPE_PYOBJECT, gobject.TYPE_PYOBJECT)
        assert self.get_flags() & gtk.TREE_MODEL_ITERS_PERSIST

        self.set_sort_func(self.COLUMN_NAME, self.__sort_name)
        self.set_sort_func(self.COLUMN_ENABLED, self.__sort_enabled)
        self.set_sort_column_id(self.COLUMN_NAME, gtk.SORT_ASCENDING)
