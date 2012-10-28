define [
  "text!templates/destination.html",
  "cs!models/map",
  "cs!models/route",
  "cs!models/location",
  "cs!collections/locations",
  "cs!views/header"
], (Template, Map, Route, Location, Locations) ->

  class Destination extends Backbone.View

    el: "#destination"
    template: _.template(Template)
    events:
      'click #destinationSubmit': "route"
    mapElement: "destination-map"
    map: null

    render: ->
      @getLocation()
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template()


    getLocation: ->
      if(@map == null)
        @map = new Map(@mapElement)


    route: (e) ->
      @directionService = new google.maps.DirectionsService()
      destination = $("#destination-input").val()

      request =
        origin: new google.maps.LatLng(utils.currentLocation.lat, utils.currentLocation.lon) # TODO: Make this LatLng work with request ..?!?!
        destination: destination
        travelMode: google.maps.DirectionsTravelMode.DRIVING

      console.log request

      @directionService.route(request, (result, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          #console.log result
          #console.log result.routes[0].overview_path

          # route
          utils.route = new Route(result)
          utils.route.setAverageSpeed()
          utils.route.save()

          # locations
          @locations(result.routes[0].overview_path)
          console.log utils.locations

          $.mobile.changePage($("#route"))
        else
          alert "Directions query failed: " + status
      )


    locations: (path) ->
      distance = 5.0
      routeBoxer = new RouteBoxer()
      boxes = routeBoxer.box(path, distance)
      utils.locations = new Locations()

      for box in boxes
        $.ajax
          url: "/api/v1/pois.json?bbox=#{box}"
          dataType: "json"
          async: false
          success: (data) =>
            if data.length > 0
              for poi in data
                location = new Location(poi)
                utils.locations.add location
            return
      utils.locations.save()

  views.destination = new Destination
