define [
  "text!templates/destination.html",
  "text!templates/error.html",
  "cs!models/map",
  "cs!models/route",
  "cs!models/location",
  "cs!collections/locations",
  "cs!views/header"
], (Template, ErrorTemplate, Map, Route, Location, Locations) ->

  class Destination extends Backbone.View

    el: "#destination"
    template: _.template(Template)
    errorTemplate: _.template(ErrorTemplate)
    events:
      "tap .category-filter": "categories"
      "tap #destinationSubmit": "route"
      "keyup input": "handleEnter"
    mapElement: "destination-map"

    render: ->
      @getLocation()
      views.header.render(@el)
      utils.menuSelect("destination")
      $("#" + @el.id + " div[data-role='content']").html(@template()).trigger("create")


    categories: (e) ->
      utils.setCategory(e)


    getLocation: ->
      if(utils.destinationMap == null)
        utils.destinationMap = new Map(@mapElement)


    handleEnter: (e) ->
      if(e.keyCode == 13)
        @route(e)


    route: (e) ->
      $.mobile.showPageLoadingMsg();
      @directionService = new google.maps.DirectionsService()
      destination = $("#destination-input").val()

      if(utils.currentLocation == null)
        utils.app.navigate "#error?reason=location", true, true
        return

      request =
        origin: new google.maps.LatLng(utils.currentLocation.lat, utils.currentLocation.lon)
        destination: destination
        travelMode: google.maps.DirectionsTravelMode.DRIVING

      @directionService.route(request, (result, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          $("#message").addClass("hidden");

          utils.route = new Route(result)
          utils.route.setAverageSpeed()
          utils.route.save()

          @locations(result.routes[0].overview_path)

          $.mobile.hidePageLoadingMsg();
          $.mobile.changePage($("#route"))
        else
          $.mobile.hidePageLoadingMsg();
          $("#message").html(@errorTemplate(reason: "destination")).trigger("create")
      )


    locations: (path) ->
      distance = 5.0
      routeBoxer = new RouteBoxer()
      boxes = routeBoxer.box(path, distance)
      utils.locations = new Locations()

      for box in boxes
        $.ajax
          url: "/api/v4/pois.json?bbox=#{box}"
          dataType: "json"
          async: false
          global: false
          success: (data) =>
            if data.length > 0
              for poi in data
                location = new Location(poi)
                if location.get("time") > 15*60
                  # only add locations after 15mins from start
                  utils.locations.add location
            return
      utils.locations.save()
      $.ajaxSetup({global: true});

    fonectaLocations: (path) ->
      distance = 5.0
      routeBoxer = new RouteBoxer()
      boxes = routeBoxer.box(path, distance)
      utils.locations = new Locations()
      for box in boxes
        $.ajax
          url: "http://developer.fonecta.net/osuma/resource/search/osuma/companies/boundingbox"
          data:
            minLatitude: box.ca.b
            maxLatitude: box.ca.f
            minLongitude: box.ea.b
            maxLongitude: box.ea.f
          dataType: "json"
          async: false
          global: false
          success: (data) =>
            if data.length > 0
              for poi in data
                location = new Location(poi)
                utils.locations.add location
            return
      utils.locations.save()
      $.ajaxSetup({global: true});

  views.destination = new Destination
