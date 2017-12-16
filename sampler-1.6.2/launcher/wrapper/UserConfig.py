import Keys


class UserConfig(object):
    '''User preferences for an instrumened application.'''

    __slots__ = ['__client', '__namespace']

    def __init__(self, name):
        '''Look for preferences under GConf area for the given application.'''
        import gconf
        self.__client = gconf.client_get_default()
        self.__namespace = Keys.applications + '/' + name

    def __key(self, extension):
        return self.__namespace + '/' + extension

    def asked(self):
        '''Check whether we have asked the user to participate.'''

        return self.__client.get_bool(Keys.asked)

    def enabled(self):
        '''Check whether sampling is enabled for this application.'''

        if not self.asked():
            return 0

        if not self.__client.get_bool(Keys.master):
            return 0

        return self.__client.get_bool(self.__key('enabled'))

    def show_tray_icon(self):
        '''Check whether a tray icon should be displayed whenever instrumented apps are running.'''
        return self.__client.get_bool(Keys.show_tray_icon)

    def sparsity(self):
        '''Sparsity of sampled data, or 0 if sampling is disabled.'''

        if self.enabled():
            return self.__client.get_int(self.__key('sparsity'))
        else:
            return 0

    def change_sparsity(self, sparsity):
        '''Record a new sampling sparsity for future runs.'''
        self.__client.set_int(self.__key('sparsity'), sparsity)

    def reporting_url(self):
        '''Destination address for uploaded reports.'''
        return self.__client.get_string(self.__key('reporting-url'))

    def change_reporting_url(self, url):
        '''Record a new address for future uploads.'''
        self.__client.set_string(self.__key('reporting-url'), url)
