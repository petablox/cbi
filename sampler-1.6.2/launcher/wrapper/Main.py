########################################################################
#
#  Backward compatibility adaptor
#


def main(configdir, wrapped = 'executable'):
    import os.path
    from ConfigParser import ConfigParser
    import Main2

    configfile = os.path.join(configdir, 'config')
    config = ConfigParser()
    config.readfp(file(configfile))

    name = config.get('upload-headers', 'application-name')
    wrapped = os.path.join(configdir, wrapped)

    upload_headers = {}
    for (key, value) in config.items('upload-headers'):
        upload_headers[key] = value

    return Main2.main(name = name,
                      wrapped = wrapped,
                      upload_headers = upload_headers)
