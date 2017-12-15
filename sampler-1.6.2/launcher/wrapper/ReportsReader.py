########################################################################
#
#  Read report stream from instrumented application and split it apart
#  into individual reports
#

class ReportsReader (dict):
    def __init__(self, source):
        import re
        lines = source.__iter__()
        startTag = re.compile('^<report id="([^"]+)">\n$')

        for line in lines:
            match = startTag.match(line)
            if match:
                name = match.group(1)
                if not name in self:
                    import cStringIO
                    self[name] = cStringIO.StringIO()

                for line in lines:
                    if line == '</report>\n':
                        break
                    else:
                        self[name].write(line)
