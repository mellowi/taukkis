# -*- coding: utf-8 -*-
from __future__ import print_function
import md5
import csv
import re
import unicodedata
import codecs
import sys

o8 = codecs.getwriter('utf-8')(sys.stdout)
e8 = codecs.getwriter('utf-8')(sys.stderr)


def unicode_csv_reader(unicode_csv_data, dialect=csv.excel, **kwargs):
    # csv.py doesn't do Unicode; encode temporarily as UTF-8:
    csv_reader = csv.reader(utf_8_encoder(unicode_csv_data),
                            dialect=dialect, **kwargs)
    for row in csv_reader:
        # decode UTF-8 back to Unicode, cell by cell:
        yield [unicode(cell, 'utf-8') for cell in row]

def utf_8_encoder(unicode_csv_data):
    for line in unicode_csv_data:
        yield line.encode('utf-8')

def report_unknown_format(linenum, line):
    try:
        print(u"! Unknown format, line {0}: {1}".format(linenum, line.replace("\n", ""), file=e8))
    except UnicodeEncodeError, uee:
        print(uee, file=e8)

def make_id(s):
    return md5.new(s.encode('ascii', 'ignore')).hexdigest()[0:6]

def slugify(string):
    return re.sub(r'[-\s]+', '-',
                  unicode(re.sub(r'[^\w\s-]', '', unicodedata.normalize('NFKD', string).encode('ascii', 'ignore')).strip().lower()))
