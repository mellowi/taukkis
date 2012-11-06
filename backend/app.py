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
from utils import *
from fra_cache import bbox_search
from fra_cache import info as fra_info


o8 = codecs.getwriter('utf-8')(sys.stdout)
e8 = codecs.getwriter('utf-8')(sys.stderr)

try:
    import requests
except ImportError, e:
    print(u"! Cannot import requests! Osuma API will not work!", file=e8)


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


class POIBase(object):
    def __init__(self, id, lon, lat, title, location):
        self.id = id
        self.lon = lon
        self.lat = lat
        self.title = title
        self.location = location

    def to_dict(self):
        raise NotImplemented

    def __repr__(self):
        return "<%s %s %s>" % (self.__class__.__name__, self.id, str(self))
    def __str__(self):
        return unicode(self).encode('ASCII', 'backslashreplace')
    def __unicode__(self):
        return u"{0}, {1}, {2} ({3}, {4})".format(self.id, self.title, self.location, self.lat, self.lon)


class POI(POIBase):
    def __init__(self, id, lon, lat, title, location, category):
        super(POI, self).__init__(id, lon, lat, title, location)
        assert(isinstance(category, basestring))
        self.category = category
        self.categories = [category]

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
        def get_location(osuma_dict):
            if 'address' in d:
                a = d['address']
                if 'cityName' in d:
                    return "%s %s, %s" % (a['street'], a['streetNumber'], d['cityName'])
                else:
                    return "%s %s, %s" % (a['street'], a['streetNumber'], a['postOffice'])
            elif 'cityName' in d and 'cityDistricts' in d:
                return "%s, %s" % (d['cityDistricts'][0], d['cityName'])
            elif 'cityName' in d:
                return d['cityName']

            raise CannotParseLocation

        try:
            location = get_location(d)
        except:
            print("! Cannot parse location from %s!" % json.dumps(d, indent=2), file=e8)
            location = ""

        return POI(d['companyId'],
                   d['coordinate']['longitude'], d['coordinate']['latitude'],
                   d['name'],
                   location,
                   category)

    def to_dict(self):
        result = {}
        for attr in ['id', 'lon', 'lat', 'title', 'location', 'category']:
            result[attr] = getattr(self, attr)
        return result

class POIWithCategories(POIBase):
    allowed_categories = set(["gas_station", "cafe", "kiosk", "sights", "fast_food",
                              "restaurant", "swimming_place", "leisure", "weather_station"])

    def __init__(self, id, lon, lat, title, location, categories):
        super(POIWithCategories, self).__init__(id, lon, lat, title, location)
        assert(not isinstance(categories, basestring))

        for cat in categories:
            assert(cat in self.__class__.allowed_categories)

        self.categories = categories

    def to_dict(self):
        result = {}
        for attr in ['id', 'lon', 'lat', 'title', 'location', 'categories']:
            result[attr] = getattr(self, attr)
        return result


def read_pois(file):
    """
    Reads curated_sights.csv
    """
    result = []

    with codecs.open(file, 'r', encoding='utf-8') as f:
        for linenum, line in enumerate(f):
            parts = [item.strip() for item in line.replace("\n", "").split(",") if len(item) > 0]
            # print(u', '.join(parts), file=o8)
            if len(parts) < 5 or len(parts) > 7:
                try:
                    print(u"! Unknown format, line {0}: {1}".format(linenum, line.replace("\n", ""), file=e8))
                except UnicodeEncodeError, uee:
                    # traceback.print_exc()
                    print(uee, file=e8)
            else:
                result.append(POI.from_list(linenum, parts))

    print(u"# Loaded {0} POIs!".format(len(result)), file=e8)
    return result

def read_swimming_places(file):
    result = []

    with codecs.open(file, 'r', encoding='iso-8859-1') as f:
        reader = unicode_csv_reader(f)
        try:
            for row in reader:
                if len(row) != 6:
                    report_unknown_format(reader.csv_reader.line_num, row)

                p = POIWithCategories(slugify(u"{0}, {1}".format(row[1], row[0])),
                                      float(row[5]), float(row[4]),
                                      row[1], row[0],
                                      ['swimming_place'])
                result.append(p)
        except csv.Error, e:
            print(e, file=e8)

    print(u"# Loaded {0} swimming places!".format(len(result)), file=e8)
    return result

def read_leisure_places(file):
    result = []

    with codecs.open(file, 'r', encoding='iso-8859-1') as f:
        reader = unicode_csv_reader(f)
        try:
            for row in reader:
                if len(row) != 6:
                    report_unknown_format(reader.csv_reader.line_num, row)

                p = POIWithCategories(slugify(row[1]),
                                      float(row[5]), float(row[4]),
                                      row[1] + u", " + row[0], u"",
                                      ['leisure'])
                result.append(p)
        except csv.Error, e:
            print(e, file=e8)

    print(u"# Loaded {0} spots de leisure!".format(len(result)), file=e8)
    return result

def read_rolls(file):
    # 62.6047211,29.7618465,Joensuu, Rolls Express
    result = []

    with codecs.open(file, 'r', encoding='utf-8') as f:
        for linenum, line in enumerate(f):
            parts = [item.strip() for item in line.replace("\n", "").split(",") if len(item) > 0]
            # print(u', '.join(parts), file=o8)
            if len(parts) != 4:
                try:
                    print(u"! Unknown format, line {0}: {1}".format(linenum, line.replace("\n", ""), file=e8))
                except UnicodeEncodeError, uee:
                    # traceback.print_exc()
                    print(uee, file=e8)
            else:
                # def __init__(self, id, lon, lat, title, location, category):
                result.append(POIWithCategories(slugify(u"{0}, {1}".format(parts[3], parts[2])),
                                  float(parts[1].strip('"')),
                                  float(parts[0].strip('"')),
                                  unicode(parts[3].strip('"')) + u", " + unicode(parts[2].strip('"')), "",
                                  ['fast_food']))

    print(u"# Loaded {0} spots de Rolls!".format(len(result)), file=e8)
    return result

def read_st1_stations(file):
    # 65.742354,24.576449,St1 Kemi Karjalahti Karjalahdenkatu 34 94600 Kemi
    result = []

    with codecs.open(file, 'r', encoding='iso-8859-1') as f:
        for linenum, line in enumerate(f):
            parts = [item.strip() for item in line.replace("\n", "").split(",") if len(item) > 0]
            # print(u', '.join(parts), file=o8)
            if len(parts) != 3:
                try:
                    print(u"! Unknown format, line {0}: {1}".format(linenum, line.replace("\n", ""), file=e8))
                except UnicodeEncodeError, uee:
                    traceback.print_exc()
                    print(uee, file=e8)
            else:
                categories = ["gas_station"]
                name = unicode(parts[2].strip('"').strip(" "))
                if name.lower().find("st1") == 0:
                    if name.lower().find("automa") == -1: # not automat or automaatti
                        categories += ["cafe"]
                elif name.lower().find("shell") == 0:
                    if name.lower().find("express") == -1 and name.lower().find("automa") == -1:
                        categories += ["cafe"]
                        categories += ["restaurant"]

                if name.lower().find("express") == -1 and name.lower().find("automa") == -1:
                    name = " ".join(name.split(" ")[:3]) # trolol
                else:
                    name = " ".join(name.split(" ")[:4]) # trolol

                # def __init__(self, id, lon, lat, title, location, category):
                result.append(POIWithCategories(slugify(name),
                                                float(parts[1].strip('"').strip(" ")),
                                                float(parts[0].strip('"').strip(" ")),
                                                name, "", categories))

    print(u"# Loaded {0} St1 stations!".format(len(result)), file=e8)
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

    lob_codes = [category_map[cat] for cat in categories
                 if cat in category_map] # Not all categories are in Osuma (e.g. swimming_place, leisure)
    for lob_code in lob_codes:
        started = time.time()
        url = make_osuma_url(bbox.bottom, bbox.left, bbox.top, bbox.right, lobCode=lob_code)
        r = make_osuma_request(url)
        if r.status_code == 200:
            results.append((url, r.text))
        else:
            print(r.status_code + " " + r.text, file=e8)

        ended = time.time()
        print("# Request {0} took {1}s".format(url, ended-started), file=e8)

    started = time.time()
    result = []
    for url, res_text in results:
        res_dict = json.loads(res_text)
        res = res_dict['results']

        for item in res:
            # print(json.dumps(item, indent=2, ensure_ascii=False), file=o8)
            result.append(POI.from_OSUMA_dict(item, lob_map[item['mainLineOfBusinessCode']]))
    ended = time.time()
    print("# Parsing and transformation took {1}s".format(url, ended-started), file=e8)

    response.content_type = 'application/json'
    return json.dumps([poi.to_dict() for poi in result], ensure_ascii=False)

@route('/api/v3/pois.json')
def pois_v3():
    global _pois
    categories = get_categories(request.query)
    if categories:
        cats_set = set(categories)
    else:
        cats_set = set(POIWithCategories.allowed_categories)
    bounding_box = get_bounding_box(request.query)

    result = []
    for poi in _pois:
        poi_cats_set = set(poi.categories)

        if categories is not None and len(poi_cats_set & cats_set) == 0:
            continue
        elif categories is not None and len(poi_cats_set & cats_set) > 0:
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

@route('/api/v4/pois.json')
def pois_v4():
    global _pois, _FRA_CACHE
    categories = get_categories(request.query)
    if categories:
        cats_set = set(categories)
    else:
        cats_set = set(POIWithCategories.allowed_categories)
    bounding_box = get_bounding_box(request.query)

    result = []
    for poi in _pois:
        poi_cats_set = set(poi.categories)

        if categories is not None and len(poi_cats_set & cats_set) == 0:
            continue
        elif categories is not None and len(poi_cats_set & cats_set) > 0:
            if bounding_box and bounding_box.contains(poi.lat, poi.lon):
                result.append(poi)
            elif bounding_box is None:
                result.append(poi)
        elif categories is None:
            if bounding_box and bounding_box.contains(poi.lat, poi.lon):
                result.append(poi)
            elif bounding_box is None:
                result.append(poi)


    result = [poi.to_dict() for poi in result]

    if 'weather_station' in cats_set:
        if bounding_box:
            stations = bbox_search(_FRA_CACHE, bounding_box.bottom, bounding_box.left,
                                   bounding_box.top, bounding_box.right)
        else:
            stations = bbox_search(_FRA_CACHE, None, None, None, None)

        for station in stations:
            station['id'] = slugify(u"{0}-{1}".format(station['name'], station['stationid']))
            station['title'] = u"Tiehallinnon sääasema {0}".format(station['name'])
            del station['name']
            station['location'] = u"{0}, {0}".format(station['municipality'],
                                                     station['fra_region'])
            station['categories'] = ['weather_station']
            result.append(station)

    response.content_type = 'application/json'
    return json.dumps(result, ensure_ascii=False)

@route('/api/v4/fra_status.json')
def fra_status():
    global _pois, _FRA_CACHE
    response.content_type = 'application/json'
    return json.dumps(fra_info(_FRA_CACHE), ensure_ascii=False)

if __name__ == '__main__':
    from optparse import OptionParser

    parser = OptionParser()
    parser.add_option("--host", dest="host",
                      help="bind to HOST", metavar="HOST", default="localhost")
    parser.add_option("--port", dest="port",
                      help="bind to PORT", metavar="PORT", type="int", default=8022)

    parser.add_option("-p", "--poi-file", dest="poi_file",
                      help="read points of interests from FILE", metavar="FILE", default="../data/curated_sights.csv")
    parser.add_option("--swimming-place-file", dest="swimming_place_file",
                      help="read swimming places from FILE", metavar="FILE", default="../data/rannat.csv")
    parser.add_option("--leisure-place-file", dest="leisure_place_file",
                      help="read leisure places from FILE", metavar="FILE", default="../data/kyrsae.csv")
    parser.add_option("--st1-stations-file", dest="st1_stations_file",
                      help="read ST1 stations from FILE", metavar="FILE", default="../data/gps-csv-st1.csv")
    parser.add_option("--rolls-file", dest="rolls_file",
                      help="read Rolls from FILE", metavar="FILE", default="../data/rollsit.csv")
    parser.add_option("--fra-cache", dest="fra_cache_file",
                      help="read FRA cache from FILE", metavar="FILE", default="fra.db")

    parser.add_option("-d", "--debug",
                      action="store_true", dest="debug", default=False,
                      help="print extra debug output")

    opts, args = parser.parse_args()
    _FRA_CACHE = opts.fra_cache_file

    _pois = []
    try:
        pass
        # _pois = read_pois(opts.poi_file)
    except:
        traceback.print_exc()

    try:
        _pois = _pois + read_swimming_places(opts.swimming_place_file)
    except:
        traceback.print_exc()

    try:
        _pois = _pois + read_leisure_places(opts.leisure_place_file)
    except:
        traceback.print_exc()

    try:
        _pois += read_st1_stations(opts.st1_stations_file)
    except:
        traceback.print_exc()

    try:
        _pois += read_rolls(opts.rolls_file)
    except:
        traceback.print_exc()

    print(u"# {0} spots total!".format(len(_pois)), file=o8)

    ids = set()
    for poi in _pois:
        if poi.id in ids:
            print(u"! Duplicate poi id: {0}".format(poi.id, file=o8))
        ids.add(poi.id)
    print(u"# {0} unique poi ids!".format(len(ids), file=o8))

    if 'FONECTA_USER_ID' not in env:
        print("# FONECTA_USER_ID not in environment!", file=e8)
    run(host=opts.host, port=opts.port)
