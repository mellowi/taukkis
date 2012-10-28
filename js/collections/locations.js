// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["models/location", "models/filter"], function(Location, Filter) {
    var Locations;
    return Locations = (function(_super) {

      __extends(Locations, _super);

      function Locations() {
        return Locations.__super__.constructor.apply(this, arguments);
      }

      Locations.prototype.id = "locations";

      Locations.prototype.model = Location;

      Locations.prototype.updateAll = function() {
        var location, _i, _len, _ref, _results;
        _ref = this.models;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          location = _ref[_i];
          _results.push(location.update());
        }
        return _results;
      };

      Locations.prototype.fetch = function(options) {
        var data, json;
        json = localStorage.getItem(this.id);
        if (json) {
          data = JSON.parse(json);
          return this.add(data);
        }
      };

      Locations.prototype.save = function(attributes, options) {
        return localStorage.setItem(this.id, JSON.stringify(this));
      };

      Locations.prototype.destroy = function() {
        return localStorage.removeItem(this.id);
      };

      Locations.prototype.sortById = function() {
        return this.sortBy(function(model) {
          return model.get("id");
        });
      };

      Locations.prototype.sortByCategory = function() {
        return this.sortBy(function(model) {
          return model.get("category");
        });
      };

      Locations.prototype.sortByDistance = function() {
        return this.sortBy(function(model) {
          return model.get("distance");
        });
      };

      Locations.prototype.sortByTime = function() {
        return this.sortBy(function(model) {
          return model.get("time");
        });
      };

      Locations.prototype.getById = function(id) {
        return this.models.filter(function(model) {
          if (parseInt(id) === model.get("id")) {
            return true;
          }
          return false;
        });
      };

      Locations.prototype.filterCategory = function(category) {
        return this.models.filter(function(model) {
          if (category === model.get("category")) {
            return true;
          }
          return false;
        });
      };

      Locations.prototype.filterCategories = function(categories) {
        return this.models.filter(function(model) {
          if ($.inArray(model.get("category"), categories) > -1) {
            return true;
          }
          return false;
        });
      };

      Locations.prototype.filterOutCategories = function() {
        return this.models.filter(function(model) {
          if ($.inArray(model.get("category"), utils.filter.get("categoriesOut")) > -1) {
            return false;
          }
          return true;
        });
      };

      return Locations;

    })(Backbone.Collection);
  });

}).call(this);
