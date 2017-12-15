class Outcome(object):
    '''Outcome of one run of a sampled application.'''

    __slots__ = ['reports', 'signal', 'sparsity', 'status']

    def __init__(self):
        self.reports = None
        self.signal = None
        self.status = None
        self.sparsity = None

    def exit(self):
        '''Propagate exit status out to whoever ran this wrapper script.'''
        import sys
        sys.exit(self.signal or self.status)

    def upload_headers(self):
        '''Contribute additional headers to report uploads.'''
        return {'sparsity' : str(self.sparsity),
                'exit-status' : str(self.status),
                'exit-signal' : str(self.signal)}
