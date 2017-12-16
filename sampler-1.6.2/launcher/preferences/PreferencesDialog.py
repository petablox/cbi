import Keys


class PreferencesDialog(object):

    __slots__ = ['__apps_group', '__client', '__dialog', '__dir', '__icon', '__master', '__notifier']

    def __init__(self):
        import gtk.glade
        import Paths
        import Signals
        xml = gtk.glade.XML(Paths.glade, 'preferences')
        Signals.autoconnect(self, xml)
        self.__dialog = xml.get_widget('preferences')

        import gconf
        from GConfDir import GConfDir
        self.__client = gconf.client_get_default()
        self.__dir = GConfDir(self.__client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

        from AppFinder import AppFinder
        from AppModel import AppModel
        from Application import Application
        finder = AppFinder(self.__client)
        model = AppModel()
        for path in finder:
            Application(self.__client, model, path)

        from MasterNotifier import MasterNotifier
        from WindowIcon import WindowIcon
        self.__master = xml.get_widget('master')
        self.__apps_group = xml.get_widget('apps-group')
        self.__notifier = MasterNotifier(self.__client, self.__master_refresh)
        self.__icon = WindowIcon(self.__client, self.__dialog)

        view = xml.get_widget('applications')

        import gtk
        selection = view.get_selection()
        selection.set_mode(gtk.SELECTION_NONE)

        renderer = gtk.CellRendererText()
        column = gtk.TreeViewColumn('Application', renderer)
        column.set_cell_data_func(renderer, self.__name_data_func)
        column.set_sort_column_id(model.COLUMN_NAME)
        column.set_reorderable(True)
        column.set_resizable(True)
        view.append_column(column)

        renderer = gtk.CellRendererToggle()
        renderer.connect('toggled', self.on_application_toggled, model)
        column = gtk.TreeViewColumn('Enabled', renderer)
        column.set_cell_data_func(renderer, self.__enabled_data_func)
        column.set_sort_column_id(model.COLUMN_ENABLED)
        column.set_reorderable(True)
        view.append_column(column)

        view.set_model(model)

    def __name_data_func(self, column, renderer, model, iter):
        __pychecker__ = 'no-argsused'
        app = model.get_value(iter, model.COLUMN_NAME)
        renderer.set_property('text', app.name)

    def __enabled_data_func(self, column, renderer, model, iter):
        __pychecker__ = 'no-argsused'
        app = model.get_value(iter, model.COLUMN_ENABLED)
        renderer.set_property('active', app.get_enabled())

    def on_master_toggled(self, master):
        active = master.get_active()
        self.__client.set_bool(Keys.master, active)

    def __master_refresh(self, enabled):
        self.__master.set_active(enabled)
        self.__apps_group.set_sensitive(enabled)

    def on_application_toggled(self, renderer, path, model):
        __pychecker__ = 'no-argsused'
        path = int(path)
        iterator = model.get_iter(path)
        app = model.get_value(iterator, model.COLUMN_ENABLED)
        app.set_enabled(not app.get_enabled())

    def on_dialog_delete(self, dialog, event):
        return True

    def on_dialog_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return True
        else:
            return False

    def present(self):
        return self.__dialog.present()

    def run(self):
        return self.__dialog.run()
