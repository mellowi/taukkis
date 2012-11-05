#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
A tool for building a FRA road weather cache database for the Taukkis backend.

Usage:
    fra_cache.py build [options]
    fra_cache.py info [options]

Options:
    -h --help                         Show this screen
    -d <db>, --database=<db>          FILE to use as the database
    -i <input>, --input-file=<input>  FILE to read static data from [default: ../data/Meta_RWS_stations.csv]
"""
from __future__ import print_function
import traceback
import codecs
import json
import sys
import sqlite3
from datetime import datetime
from os import environ as env
from coordinates import Str_to_CoordinateValue
from docopt import docopt
from utils import *

try:
    from suds.client import Client
except ImportError, ie:
    print("! Cannot import suds, unable to build database!", file=e8)

o8 = codecs.getwriter('utf-8')(sys.stdout)
e8 = codecs.getwriter('utf-8')(sys.stderr)

URL = "http://stp.gofore.com/sujuvuus/ws/roadWeather?wsdl"

CREATE_TABLE = '''CREATE TABLE stations
                   (stationid int,
                    name text,
                    road text,
                    municipality text,
                    fra_region text,
                    lat float,
                    lon float,
                    airtemperature1 float,
                    humidity int,
                    measurementtime datetime,
                    warning1 int,
                    warning2 int,
                    precipitation int,
                    precipitationtype int,
                    roadsurfaceconditions1 int,
                    roadsurfaceconditions2 int)'''

# "CREATE INDEX name_idx ON places (name)",
CREATE_INDEX = "CREATE INDEX stationid_idx ON stations (stationid)"


class RoadWeatherStation(object):
    """
    airtemperature1
    measurementtime
    humidity
    warning1 anturi 29 (VAROITUS_1)
    warning2 anturi 30 (VAROITUS_2)
    precipitation anturi 22 (SADE)
    roadsurfaceconditions1 anturi 27 (KELI_1)
    roadsurfaceconditions2 anturi 28 (KELI_2)
    precipitationtype anturi 25 (SATEEN_OLOMUOTO_FD12P_PWD11)
    """
    ATTRS = (
        'stationid',
        'airtemperature1',
        'humidity',
        'measurementtime',
        'warning1',
        'warning2',
        'precipitation',
        'precipitationtype',
        'roadsurfaceconditions1',
        'roadsurfaceconditions2'
        )

    STATIC_ATTRS = (
        'name',
        'road',
        'lat',
        'lon',
        'municipality',
        'fra_region'
        )

    ALLOW_MISSING = (
        'precipitation',
        'precipitationtype',
        'warning1',
        'warning2',
        'roadsurfaceconditions1',
        'roadsurfaceconditions2',
        )

    def __init__(self, **kwargs):
        for attr in self.__class__.ATTRS + self.__class__.STATIC_ATTRS:
            try:
                setattr(self, attr, kwargs[attr])
            except Exception, e:
                if attr in self.__class__.ALLOW_MISSING:
                    pass
                else:
                    traceback.print_exc()

    @classmethod
    def from_suds_object(cls, obj, static):
        """
        static is a dict in the form id => {}
        """
        d = static[obj.stationid]

        for attr in cls.ATTRS:
            try:
                if 'time' in attr:
                    d[attr] = getattr(obj, datetime.strptime(attr.utc))
                else:
                    d[attr] = getattr(obj, attr)
            except Exception, e:
                if attr in cls.ALLOW_MISSING:
                    pass
                else:
                    traceback.print_exc()

        return RoadWeatherStation(**d)

    def insert_stmt(self):
        attrs = []
        attr_values = []

        for attr in self.__class__.ATTRS + self.__class__.STATIC_ATTRS:
            if hasattr(self, attr):
                attrs.append(attr)
                attr_values.append(getattr(self, attr))

        return (u"INSERT INTO stations ({0}) VALUES ({1})".format(', '.join(attrs),
                                                                 ', '.join(['?' for i in xrange(len(attrs))])),
                attr_values)

    def __repr__(self):
        return "<%s %s %s>" % (self.__class__.__name__, self.stationid, str(self))
    def __str__(self):
        return unicode(self).encode('ASCII', 'backslashreplace')
    def __unicode__(self):
        return u""


def read_static_data(file):
    # 16013,vt1_Karnainen_Opt,1,13,4246,6692812,3334497,0,444,Lohja,Uusimaa,,60,18,"45,7",24,0,7
    # u'NUMERO', u'TSA_NIMI', u'TIE', u'TIEOSA', u'ETAISYYS', u'X', u'Y',
    # 0          1            2       3          4            5     6
    # u'KORKEUS', u'KUNTAKOODI', u'KUNNAN_NIMI', u'TIEPIIRIN_NIMI', u'SIJOITTELU',
    # 7           8              9               10                 11
    # u'LEVEYS_ASTE', u'LEVEYS_MINUUTTI', u'LEVEYS_SEKUNTI', u'PITUUS_ASTE',
    # 12              13                  14                 15
    # u'PITUUS_MINUUTTI', u'PITUUS_SEKUNTI'
    # 16                  17
    result = {}

    with codecs.open(file, 'r', encoding='utf-8') as f:
        reader = unicode_csv_reader(f)
        try:
            for row in reader:
                if row[0] == u'NUMERO':
                    continue # header row

                if len(row) != 18:
                    report_unknown_format(reader.csv_reader.line_num, row)

                id = str(row[0])
                result[id] = {
                    'name': row[1],
                    'road': row[2],
                    'lat': float(Str_to_CoordinateValue(u"{0},{1},{2}".format(row[12],
                                                                              row[13],
                                                                              row[14].replace(',', '.')))),
                    'lon': float(Str_to_CoordinateValue(u"{0},{1},{2}".format(row[15],
                                                                              row[16],
                                                                              row[17].replace(',', '.')))),
                    
                    'municipality': row[9],
                    'fra_region': row[10]
                    }

        except csv.Error, e:
            print(e, file=e8)

    print(u"# Loaded {0} stations from static!".format(len(result)), file=e8)
    return result


def stations(user, password, static):
    client = Client(URL, username=user, password=password)
    road_weather = client.service.RoadWeather()
    data = road_weather.roadweatherdata.roadweather

    result = []
    for d in data:
        try:
            station = RoadWeatherStation.from_suds_object(d, static)
            result.append(RoadWeatherStation.from_suds_object(d, static))
        except KeyError, ke:
            traceback.print_exc()
    return result

def build(input_file, database, user, password):
    conn = sqlite3.connect(database)
    c = conn.cursor()
    c.execute(CREATE_TABLE)
    c.execute(CREATE_INDEX)
    conn.commit()

    static = read_static_data(input_file)
    stations_list = stations(user, password, static)

    for station in stations_list:
        c.execute(*station.insert_stmt())
    conn.commit()


def info(database):
    conn = sqlite3.connect(database)
    c = conn.cursor()
    c.execute('''SELECT COUNT(stationid), AVG(airtemperature1),
                 MIN(airtemperature1), MAX(airtemperature1) FROM stations''')
    row = c.fetchone()
    station_count, avg_temp, min_temp, max_temp = row
    return { 'station_count': station_count,
             'average_temperature': avg_temp,
             'maximum_temperature': max_temp,
             'minimum_temperature': min_temp }

def bbox_search(database, minlat, minlon, maxlat, maxlon):
    conn = sqlite3.connect(database)
    c = conn.cursor()

    attrs = []

    for attr in RoadWeatherStation.ATTRS + RoadWeatherStation.STATIC_ATTRS:
        attrs.append(attr)

    c.execute(u"""SELECT {0} FROM stations WHERE
                  lat > ? AND lat < ? AND lon > ? AND lon < ?""".format(', '.join(attrs)),
        (minlat, maxlat, minlon, maxlon))

    result = []
    for row in c.fetchall():
        d = {}
        for idx, attr in enumerate(attrs):
            d[attr] = row[idx]
        result.append(d)
    return result
            

if __name__ == '__main__':
    args = docopt(__doc__)
    # print(args)

    db = args['--database']
    if not isinstance(db, basestring):
        sys.exit("--database not defined!")

    if args['build']:
        build(input_file=args['--input-file'],
              database=db, user=env['DIGITRAFFIC_USER'],
              password=env['DIGITRAFFIC_PASSWORD'])
    elif args['info']:
        # result = bbox_search(db, 60, 20, 70, 30)
        # print(json.dumps(result, ensure_ascii=False, indent=2), file=o8)
        result = info(db)
        print(json.dumps(result, ensure_ascii=False, indent=2), file=o8)
