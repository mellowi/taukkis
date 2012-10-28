#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import codecs
import json
import traceback
import time

from os import environ as env

from bottle import route, run, get, request, response

import requests

o8 = codecs.getwriter('utf-8')(sys.stdout)
e8 = codecs.getwriter('utf-8')(sys.stderr)

class BoundingBox(object):
    def __init__(self, box):
        self.bottom, self.left, self.top, self.right = [float(i) for i in box.split(",")]

    def contains(self, lat, lon):
        return (lon > self.left and lon < self.right and
                lat > self.bottom and lat < self.top)

    def __repr__(self):
        return "<Bounding Box (%s, %s), (%s, %s)>" % (self.left, self.bottom, self.right, self.top)
    def __str__(self):
        return unicode(self).encode('ASCII', 'backslashreplace')
    def __unicode__(self):
        return u"({0}, {1}), ({2}, {3})".format(self.left, self.bottom, self.right, self.top)

class POI(object):
    def __init__(self, id, lon, lat, title, location, category):
        self.id = id
        self.lon = lon
        self.lat = lat
        self.title = title
        self.location = location
        self.category = category

    @classmethod
    def from_list(cls, id, lst):
        lon = float(lst[0])
        lat = float(lst[1])
        title = lst[2]
        location = lst[3]
        category = lst[4]
        return POI(id, lon, lat, title, location, category)

    @classmethod
    def from_OSUMA_dict(cls, d, category):
        return POI(d['companyId'],
                   d['coordinate']['longitude'], d['coordinate']['latitude'],
                   d['name'],
                   "%s %s, %s" % (d['address']['street'],
                                  d['address']['streetNumber'],
                               d['address']['street']),
                   category)

    def to_dict(self):
        result = {}

        for attr in ['id', 'lon', 'lat', 'title', 'location', 'category']:
            result[attr] = getattr(self, attr)

        return result

    def __repr__(self):
        return "<POI %s %s %s>" % (self.id, self.category, str(self))
    def __str__(self):
        return unicode(self).encode('ASCII', 'backslashreplace')
    def __unicode__(self):
        return u"{0}, {1}, {2}".format(self.id, self.title, self.location)


def read_pois(file):
    result = []

    with codecs.open(file, 'r', encoding='utf-8') as f:
        for linenum, line in enumerate(f):
            parts = [item.strip() for item in line.replace("\n", "").split(",") if len(item) > 0]
            # print(u', '.join(parts), file=o8)
            if len(parts) < 5 or len(parts) > 7:
                try:
                    print(u"! Unknown format, line {0}: {1}".format(linenum, line.replace("\n", ""), file=e8))
                except UnicodeEncodeError, uee:
                    traceback.print_exc()
                    print(uee, file=e8)
            else:
                result.append(POI.from_list(linenum, parts))

    print(u"# Loaded {0} POIs!".format(len(result)), file=e8)
    return result

def get_categories(query_dict):
    """
    Returns a list of categories as strings.
    """
    categories = query_dict.get('categories', None)
    if categories is not None:
        categories = categories.split(',')
    else:
        categories = query_dict.getall('category')
        if len(categories) == 0:
            categories = None

    return categories

def get_bounding_box(query_dict):
    bounding_box = None
    if query_dict.get('bbox', None) is not None:
        bbox = query_dict.get('bbox', None).replace("(", "").replace(")", "")
        bounding_box = BoundingBox(bbox)
    return bounding_box

@route('/api/v1/pois.json')
def pois_v1():
    global _pois
    categories = get_categories(request.query)
    bounding_box = get_bounding_box(request.query)

    result = []
    for poi in _pois:
        if categories is not None and poi.category not in categories:
            continue
        elif categories is not None and poi.category in categories:
            if bounding_box and bounding_box.contains(poi.lat, poi.lon):
                result.append(poi)
            elif bounding_box is None:
                result.append(poi)
        elif categories is None:
            if bounding_box and bounding_box.contains(poi.lat, poi.lon):
                result.append(poi)
            elif bounding_box is None:
                result.append(poi)

    response.content_type = 'application/json'
    return json.dumps([poi.to_dict() for poi in result], ensure_ascii=False)


def make_osuma_url(minLat, minLon, maxLat, maxLon, lobCode=None):
    if lobCode:
        return "http://developer.fonecta.net/osuma/resource/search/osuma/companies/boundingbox" + \
            "?lobCode=%s" % lobCode + \
            "&minLatitude=%(minLat)4f&minLongitude=%(minLon)4f" % {'minLat': minLat, 'minLon': minLon} + \
            "&maxLatitude=%(maxLat)4f&maxLongitude=%(maxLon)4f" % {'maxLat': maxLat, 'maxLon': maxLon}
    else:
        return "http://developer.fonecta.net/osuma/resource/search/osuma/companies/boundingbox" + \
            "?minLatitude=%(minLat)4f&minLongitude=%(minLon)4f" % {'minLat': minLat, 'minLon': minLon} + \
            "&maxLatitude=%(maxLat)4f&maxLongitude=%(maxLon)4f" % {'maxLat': maxLat, 'maxLon': maxLon}

def make_osuma_request(url):
    if 'FONECTA_USER_ID' in env:
        return requests.get(url, headers=
                            { 'X-FONECTA-USER-ID': env['FONECTA_USER_ID'] })
    return requests.get(url)


@route('/api/v2/pois.json')
def pois_v2():
    categories = get_categories(request.query)
    bbox = get_bounding_box(request.query)

    category_map = {
        'gas_station': '1D0050', # (Huoltoasema)
        'cafe': '1D1480', # (Kahvila)
        'kiosk': '1D1490', # (Kioski)
        'sights': '1D1220', # (Nähtävyydet)
        'fast_food': '1D1520', # (Pikaruoka)
        'restaurant': '1D1530' # (Ravintola)
        }
    lob_map = {}
    for k, v in category_map.iteritems():
        lob_map[v] = k

    if categories is None:
        categories = category_map.keys()
    else:
        for category in categories:
            if category not in category_map:
                abort(400, "Unknown category: %s not in (%s)" %
                      (category, ', '.join(categories_map.keys())))

    results = []

    for lobCode in [category_map[cat] for cat in categories]:
        url = make_osuma_url(bbox.bottom, bbox.left, bbox.top, bbox.right, lobCode=lobCode)
        started = time.clock()
        r = make_osuma_request(url)
        if r.status_code == 200:
            results.append((url, r.text))
        else:
            print(r.status_code + " " + r.text, file=e8)
        ended = time.clock()
        print("# Request {0} took {1}".format(url, ended-started))

    result = []
    for url, res_text in results:
        res_dict = json.loads(res_text)
        res = res_dict['results']

        for item in res:
            # print(json.dumps(item, indent=2, ensure_ascii=False), file=o8)
            result.append(POI.from_OSUMA_dict(item, lob_map[item['mainLineOfBusinessCode']]))

    response.content_type = 'application/json'
    return json.dumps([poi.to_dict() for poi in result], ensure_ascii=False)


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
    if 'FONECTA_USER_ID' not in env:
        print("# FONECTA_USER_ID not in environment!", file=e8)
    run(host=opts.host, port=opts.port)
