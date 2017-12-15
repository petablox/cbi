from subprocess import Popen


########################################################################


class Launcher(object):
    '''Manage launching and waiting for an application.'''

    __slots__ = ['__child', 'app']

    def __init__(self, app):
        self.app = app

    def spawnEnv(self, env):
        import sys
        self.__child = Popen(sys.argv, executable=self.app.executable, env=env)

    def spawn(self):
        raise NotImplementedError

    def prep_outcome(self, outcome):
        pass

    def wait(self):
        import Outcome
        outcome = Outcome.Outcome()
        self.prep_outcome(outcome)
        
        returncode = self.__child.wait()

        if returncode >= 0:
            outcome.status = returncode
            outcome.signal = 0
        else:
            outcome.status = 0
            outcome.signal = -returncode

        return outcome
