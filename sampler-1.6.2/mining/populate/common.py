from pyPgSQL import PgSQL
import sys


def connect():
    return PgSQL.connect(host='postgresql.cs.wisc.edu', database='cbi')


def results(cursor):
    while True:
        rows = cursor.fetchmany()
        if rows:
            for row in rows:
                yield row
        else:
            return


class Upload(object):

    __slots__ = ['__connection']

    def __init__(self, db, table):
        self.__connection = db.conn
        self.__connection.query('COPY %s FROM STDIN' % table)

    def append(self, row):
        row = map(str, row)
        for field in row:
            if '\t' in field:
                print >>sys.stderr, 'fishy tab in upload field "%s"' % field
                sys.exit(1)
        row = '\t'.join(row)
        self.__connection.putline(row + '\n')

    def commit(self):
        self.__connection.endcopy()
