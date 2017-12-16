from urllib2 import HTTPRedirectHandler


class RedirectHandler (HTTPRedirectHandler):
    '''Custom urllib2 handler that captures information about
    permanent redirections.'''

    def __init__(self):
        self.permanent = None

    def __set_permanent(self, req, newurl):
        import urlparse
        self.permanent = urlparse.urljoin(req.get_full_url(), newurl)

    def http_error_301(self, req, fp, code, msg, headers):
        if headers.has_key('location'):
            self.__set_permanent(req, headers['location'])
        elif headers.has_key('uri'):
            self.__set_permanent(req, headers['uri'])
        return HTTPRedirectHandler.http_error_301(self, req, fp, code, msg, headers)

    http_error_303 = HTTPRedirectHandler.http_error_302
    http_error_307 = HTTPRedirectHandler.http_error_302
