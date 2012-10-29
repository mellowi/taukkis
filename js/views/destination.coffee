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
      $("#" + @el.id + " div[data-role='content']").html @template()


    categories: (e) ->
      utils.setCategory(e)


    getLocation: ->
      if(utils.destinationMap == null)
        utils.destinationMap = new Map(@mapElement)


    handleEnter: (e) ->
      console.log e
      if(e.keyCode == 13)
        console.log "enter"
        @route(e)


    route: (e) ->
      console.log "route"
      $.mobile.showPageLoadingMsg();
      @directionService = new google.maps.DirectionsService()
      destination = $("#destination-input").val()

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
          $("#message").html @errorTemplate(reason: "destination")
      )


    locations: (path) ->
      distance = 5.0
      routeBoxer = new RouteBoxer()
      boxes = routeBoxer.box(path, distance)
      utils.locations = new Locations()

      for box in boxes
        $.ajax
          url: "/api/v3/pois.json?bbox=#{box}"
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
