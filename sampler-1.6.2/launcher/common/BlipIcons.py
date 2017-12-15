import gtk


########################################################################


def __source(abled, size):
    import SamplerConfig
    import os.path

    source = gtk.IconSource()
    filename = abled + '-' + str(size) + '.png'
    source.set_filename(os.path.join(SamplerConfig.pixmapsdir, filename))

    return source


def __install(abled):
    icons = gtk.IconSet()

    source_48 = __source(abled, 48)
    source_48.set_size_wildcarded(False)
    source_48.set_size(gtk.ICON_SIZE_DIALOG)
    icons.add_source(source_48)

    source_96 = __source(abled, 96)
    #source_96.set_size_wildcarded(False)
    source_96.set_size(ICON_SIZE_EMBLEM)
    icons.add_source(source_96)

    factory = gtk.IconFactory()
    factory.add('sampler-' + abled, icons)
    factory.add_default()


ICON_SIZE_EMBLEM = gtk.icon_size_register('sampler-emblem', 96, 96)

__install('disabled')
__install('enabled')

stock = ['sampler-disabled', 'sampler-enabled']
