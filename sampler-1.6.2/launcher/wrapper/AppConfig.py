class AppConfig(object):
    '''Static configuration information about a single instrumented application'''

    __slots__ = ['__upload_headers', 'executable']

    def __init__(self, name, executable, upload_headers):
        upload_headers['application-name'] = name
        upload_headers['executable-path'] = executable
        self.executable = executable
        self.__upload_headers = upload_headers

    def upload_headers(self):
        return self.__upload_headers
