// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["models/geo-locate-control"], function(GeoLocateControl) {
    var Map;
    return Map = (function(_super) {

      __extends(Map, _super);

      function Map() {
        return Map.__super__.constructor.apply(this, arguments);
      }

      Map.prototype.initialize = function(divname) {
        var bingHybrid, control, mapPosition, mapQuest, mmlTaustakartta, osmCycle;
        this.divname = divname;
        mapQuest = this.setLayerMapQuest();
        osmCycle = this.setLayerOsmCycle();
        mmlTaustakartta = this.setLayerMmlTaustakartta();
        bingHybrid = this.setLayerBingHybrid();
        mapPosition = this.loadMapPosition();
        this.geolocate = new GeoLocateControl().instance;
        this.controls = [];
        if (this.divname === "map") {
          this.controls = [
            new OpenLayers.Control.Attribution(), new OpenLayers.Control.TouchNavigation({
              dragPanOptions: {
                enableKinetic: true
              }
            }), this.geolocate, new OpenLayers.Control.Zoom()
          ];
        }
        if (this.divname === "destination-map") {
          this.controls = [this.geolocate];
        }
        this.instance = new OpenLayers.Map({
          div: this.divname,
          theme: null,
          projection: defaults.projection,
          controls: this.controls,
          layers: [mmlTaustakartta],
          eventListeners: {
            "moveend": this.storeMapPosition
          }
        });
        this.instance.setCenter(new OpenLayers.LonLat(mapPosition.longitude, mapPosition.latitude), mapPosition.zoom);
        this.instance.setBaseLayer(mapQuest);
        if (this.divname === "map" || this.divname === "destination-map") {
          control = this.instance.getControlsBy("id", "locate-control")[0];
          control.activate();
        }
        return this.instance;
      };

      Map.prototype.storeMapPosition = function(event) {
        var lonlat, mapPosition, zoomLevel;
        lonlat = event.object.getCenter();
        zoomLevel = event.object.getZoom();
        mapPosition = {
          longitude: lonlat.lon,
          latitude: lonlat.lat,
          zoom: zoomLevel
        };
        return $.JSONCookie(this.divname + '-position', mapPosition, {
          expires: 30
        });
      };

      Map.prototype.loadMapPosition = function() {
        var position;
        position = $.JSONCookie(this.divname + '-position');
        if (!position.longitude) {
          position = {
            longitude: 2777381.0927341,
            latitude: 8439319.5947809,
            zoom: 11
          };
        }
        return position;
      };

      Map.prototype.setLayerMapQuest = function() {
        return new OpenLayers.Layer.OSM("MapQuest", ["http://otile1.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png", "http://otile2.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png", "http://otile3.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png", "http://otile4.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png"], {
          transitionEffect: 'resize',
          attribution: "Data, imagery and map information provided by <a href='http://www.mapquest.com/'  target='_blank'>MapQuest</a>, <a href='http://www.openstreetmap.org/' target='_blank'>Open Street Map</a> and contributors, <a href='http://creativecommons.org/licenses/by-sa/2.0/' target='_blank'>CC-BY-SA</a>  <img src='http://developer.mapquest.com/content/osm/mq_logo.png' border='0'>"
        });
      };

      Map.prototype.setLayerOsmCycle = function() {
        return new OpenLayers.Layer.OSM("OpenStreetMap - Cycle", ["http://a.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png", "http://b.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png", "http://c.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png"], {
          transitionEffect: 'resize'
        });
      };

      Map.prototype.setLayerMmlTaustakartta = function() {
        return new OpenLayers.Layer.XYZ("Maanmittauslaitos - Taustakartta", "http://tiles.kartat.kapsi.fi/taustakartta/${z}/${x}/${y}.png", {
          sphericalMercator: true,
          attribution: "<br/>Kartta-aineisto &copy; <a class='attribution' href='http://maanmittauslaitos.fi/'>MML</a>, jakelu <a class='attribution' href='http://kartat.kapsi.fi/'>Kapsi ry</a>",
          transitionEffect: 'resize'
        });
      };

      Map.prototype.setLayerBingHybrid = function() {
        return new OpenLayers.Layer.Bing({
          name: "Bing - Hybrid",
          key: defaults.bingKey,
          type: "AerialWithLabels",
          transitionEffect: 'resize'
        });
      };

      return Map;

    })(Backbone.Model);
  });

}).call(this);
