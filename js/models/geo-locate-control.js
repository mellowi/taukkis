// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var GeoLocateControl;
    return GeoLocateControl = (function(_super) {

      __extends(GeoLocateControl, _super);

      function GeoLocateControl() {
        return GeoLocateControl.__super__.constructor.apply(this, arguments);
      }

      GeoLocateControl.prototype.initialize = function() {
        utils.geoLocateLayer = new OpenLayers.Layer.Vector("Locate");
        this.instance = new OpenLayers.Control.Geolocate({
          id: 'locate-control',
          geolocationOptions: {
            enableHighAccuracy: false,
            maximumAge: 0,
            timeout: 7000
          }
        });
        this.instance.events.register("locationupdated", this.instance, function(e) {
          utils.currentLocation = {
            lat: e.position.coords.latitude,
            lon: e.position.coords.longitude
          };
          utils.geoLocateLayer.removeAllFeatures();
          utils.geoLocateLayer.addFeatures([
            new OpenLayers.Feature.Vector(e.point, null, {
              graphicName: 'circle',
              strokeColor: '#f00',
              strokeWidth: 2,
              fillOpacity: 0.6,
              fillColor: '#f00',
              pointRadius: 8
            })
          ]);
          if (utils.locations !== null) {
            utils.locations.updateAll();
            utils.locations.save();
          }
          return console.log("Location changed:");
        });
        this.instance.events.register("locationfailed", this.instance, function(e) {
          return utils.app.navigate("#error?reason=location", true, true);
        });
        return this.instance.events.register("locationuncapable", this.instance, function(e) {
          return utils.app.navigate("#error?reason=location", true, true);
        });
      };

      return GeoLocateControl;

    })(Backbone.Model);
  });

}).call(this);
