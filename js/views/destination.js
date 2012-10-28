// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["text!templates/destination.html", "text!templates/error.html", "models/map", "models/route", "models/location", "collections/locations", "views/header"], function(Template, ErrorTemplate, Map, Route, Location, Locations) {
    var Destination;
    Destination = (function(_super) {

      __extends(Destination, _super);

      function Destination() {
        return Destination.__super__.constructor.apply(this, arguments);
      }

      Destination.prototype.el = "#destination";

      Destination.prototype.template = _.template(Template);

      Destination.prototype.errorTemplate = _.template(ErrorTemplate);

      Destination.prototype.events = {
        "tap .category-filter": "categories",
        'click #destinationSubmit': "route"
      };

      Destination.prototype.mapElement = "destination-map";

      Destination.prototype.render = function() {
        this.getLocation();
        views.header.render(this.el);
        return $("#" + this.el.id + " div[data-role='content']").html(this.template());
      };

      Destination.prototype.categories = function(e) {
        return utils.setCategory(e);
      };

      Destination.prototype.getLocation = function() {
        if (utils.destinationMap === null) {
          return utils.destinationMap = new Map(this.mapElement);
        }
      };

      Destination.prototype.route = function(e) {
        var destination, request,
          _this = this;
        $.mobile.showPageLoadingMsg();
        this.directionService = new google.maps.DirectionsService();
        destination = $("#destination-input").val();
        request = {
          origin: new google.maps.LatLng(utils.currentLocation.lat, utils.currentLocation.lon),
          destination: destination,
          travelMode: google.maps.DirectionsTravelMode.DRIVING
        };
        return this.directionService.route(request, function(result, status) {
          if (status === google.maps.DirectionsStatus.OK) {
            $("#message").addClass("hidden");
            utils.route = new Route(result);
            utils.route.setAverageSpeed();
            utils.route.save();
            _this.locations(result.routes[0].overview_path);
            $.mobile.hidePageLoadingMsg();
            return $.mobile.changePage($("#route"));
          } else {
            $.mobile.hidePageLoadingMsg();
            return $("#message").html(_this.errorTemplate({
              reason: "destination"
            }));
          }
        });
      };

      Destination.prototype.locations = function(path) {
        var box, boxes, distance, routeBoxer, _i, _len,
          _this = this;
        distance = 5.0;
        routeBoxer = new RouteBoxer();
        boxes = routeBoxer.box(path, distance);
        utils.locations = new Locations();
        for (_i = 0, _len = boxes.length; _i < _len; _i++) {
          box = boxes[_i];
          $.ajax({
            url: "/api/v1/pois.json?bbox=" + box,
            dataType: "json",
            async: false,
            global: false,
            success: function(data) {
              var location, poi, _j, _len1;
              if (data.length > 0) {
                for (_j = 0, _len1 = data.length; _j < _len1; _j++) {
                  poi = data[_j];
                  location = new Location(poi);
                  utils.locations.add(location);
                }
              }
            }
          });
        }
        utils.locations.save();
        return $.ajaxSetup({
          global: true
        });
      };

      return Destination;

    })(Backbone.View);
    return views.destination = new Destination;
  });

}).call(this);
