import cStringIO


########################################################################
#
#  Python has a great "email" package with the not-so-great assumption
#  that "\n" is always the appropriate line terminator.  HTTP mandates
#  CRLF, and there's just no practical way to convince the "email"
#  package to use this.  Furthermore, our compressed reports are
#  binary, not text, so we cannot simply replace "\n" with CRLF later.
#
#  Thus we cannot use the "email" package at all, and have to roll our
#  own crude replacement.
#
#  {sigh}
#


class Upload(object):

    __slots__ = ['__boundary', '__compressed', 'headers']

    def __init__(self, reports):
        # compress each individual report
        self.__compressed = {}
        for name in reports:
            import gzip
            import shutil
            accumulator = cStringIO.StringIO()
            compressor = gzip.GzipFile(None, 'wb', 9, accumulator)
            reports[name].seek(0)
            shutil.copyfileobj(reports[name], compressor)
            compressor.close()
            self.__compressed[name] = accumulator.getvalue()

        # pick a boundy that never appears in any report
        self.__boundary = self.__pick_boundary()
        self.headers = {'Content-type' : 'multipart/form-data; boundary="' + self.__boundary + '"'}

    def __pick_boundary(self):
        import random
        import re
        candidate = ('=' * 15) + repr(random.random()).split('.')[1] + '=='
        pattern = re.compile('^--' + re.escape(candidate) + '(--)?$', re.MULTILINE)

        for name in self.__compressed:
            if pattern.search(self.__compressed[name]):
                return self.__pick_boundary()

        return candidate

    def body(self):
        multipart = cStringIO.StringIO()

        for name in self.__compressed:
            contents = ['--' + self.__boundary,
                        'content-disposition: form-data; filename="' + name + '", name="' + name + '"',
                        'content-encoding: gzip',
                        '',
                        self.__compressed[name]]
            for line in contents:
                print >>multipart, line + '\r'

        print >>multipart, '--' + self.__boundary + '--\r'
        return multipart.getvalue()
