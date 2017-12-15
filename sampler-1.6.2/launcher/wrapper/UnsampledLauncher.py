from Launcher import Launcher


########################################################################


class UnsampledLauncher(Launcher):
    '''Launch an application with no sampling.'''

    def __init__(self, app):
        Launcher.__init__(self, app)

    def spawn(self):
        # force sampling off
        import os
        if 'SAMPLER_SPARSITY' in os.environ:
            del os.environ['SAMPLER_SPARSITY']

        # away we go!
        return self.spawnEnv(os.environ)
