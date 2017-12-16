from fcntl import *
import os

from Launcher import Launcher


########################################################################


class SampledLauncher(Launcher):
    '''Launch an application with sampling enabled.'''

    def __init__(self, app, user, sparsity):
        Launcher.__init__(self, app)
        self.__user = user
        self.__sparsity = sparsity

    def spawn(self):
        # modified environment for instrumented child process
        environ = os.environ.copy()

        # set up random number generator
        environ['SAMPLER_SPARSITY'] = str(self.__sparsity)

        # set up reporting
        self.__pipe = os.pipe()
        environ['SAMPLER_FILE'] = '/dev/fd/%d' % self.__pipe[1]
        environ['SAMPLER_REPORT_FD'] = '%d' % self.__pipe[1]
        environ['GNOME_DISABLE_CRASH_DIALOG'] = '1'
        environ['SAMPLER_REAL_EXECUTABLE'] = self.app.executable

        # away we go!
        self.spawnEnv(environ)

        # tidy up pipe ends
        os.close(self.__pipe[1])
        flags = fcntl(self.__pipe[0], F_GETFD)
        if flags >= 0:
            flags |= FD_CLOEXEC
            fcntl(self.__pipe[0], F_SETFD, flags)

        return

    def prep_outcome(self, outcome):
        import ReportsReader
        outcome.sparsity = self.__sparsity
        outcome.reports = ReportsReader.ReportsReader(os.fdopen(self.__pipe[0]))

    def wait(self):
        outcome = Launcher.wait(self)
        if self.__user.enabled():
            import Uploader
            Uploader.upload(self.app, self.__user, outcome, 'text/html')

        return outcome
