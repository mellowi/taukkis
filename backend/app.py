#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import codecs
import json

from bottle import route, run, get, request, response

o8 = codecs.getwriter('utf-8')(sys.stdout)
e8 = codecs.getwriter('utf-8')(sys.stderr)

@route('/api/v1/pois.json')
def pois_v1():
    global _pois
    categories = request.query.get('categories', None)
    if categories is not None:
        categories = categories.split(',')
    else:
        categories = request.query.getall('category')
        if len(categories) == 0:
            categories = None

    result = []
    for poi in _pois:
        if categories is not None and poi.category not in categories:
            continue
        elif categories is not None and poi.category in categories:
            result.append(poi)
        elif categories is None:
            result.append(poi)

    response.content_type = 'application/json'
    return json.dumps([poi.to_dict() for poi in result], ensure_ascii=False)


class POI(object):
    def __init__(self, lon, lat, title, location, category):
        self.lon = lon
        self.lat = lat
        self.title = title
        self.location = location
        self.category = category

    @classmethod
    def from_list(cls, lst):
        lon = float(lst[0])
        lat = float(lst[1])
        title = lst[2]
        location = lst[3]
        category = lst[4]
        return POI(lon, lat, title, location, category)

    def to_dict(self):
        result = {}

        for attr in ['lon', 'lat', 'title', 'location', 'category']:
            result[attr] = getattr(self, attr)

        return result

    def __repr__(self):
        return "<POI %s %s>" % (self.category, str(self))

    def __str__(self):
        return unicode(self).encode('ASCII', 'backslashreplace')

    def __unicode__(self):
        return u"{0}, {1}".format(self.title, self.location)

    
def read_pois(file):
    result = []

    with codecs.open(file, 'r', encoding='utf-8') as f:
        for linenum, line in enumerate(f):
            parts = [item.strip() for item in line.replace("\n", "").split(",") if len(item) > 0]
            # print(u', '.join(parts), file=o8)
            if len(parts) < 5 or len(parts) > 7:
                print(u"! Unknown format, line {0}: {1}".format(linenum, line.replace("\n", ""), file=e8))
            else:
                result.append(POI.from_list(parts))

    print(u"# Loaded {0} POIs!".format(len(result)), file=e8)
    return result

if __name__ == '__main__':
    from optparse import OptionParser

    parser = OptionParser()
    parser.add_option("--host", dest="host",
                      help="bind to HOST", metavar="HOST", default="localhost")
    parser.add_option("--port", dest="port",
                      help="bind to PORT", metavar="PORT", type="int", default=8022)

    parser.add_option("-p", "--poi-file", dest="poi_file",
                      help="read points of interests from FILE", metavar="FILE", default="../data/curated_sights.csv")
    
    parser.add_option("-d", "--debug",
                      action="store_true", dest="debug", default=False,
                      help="print extra debug output")

    opts, args = parser.parse_args()

    _pois = read_pois(opts.poi_file)
    run(host=opts.host, port=opts.port)
