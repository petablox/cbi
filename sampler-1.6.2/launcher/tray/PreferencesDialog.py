def present():
    from subprocess import Popen
    import Paths
    Popen([Paths.bin + '/sampler-preferences'])
