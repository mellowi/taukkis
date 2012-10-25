define [
  "text!templates/destination.html",
  "cs!models/route",
  "cs!models/location",
  "cs!collections/locations",
  "cs!views/header"
], (Template, Route, Location, Locations) ->

  class Destination extends Backbone.View

    el: "#destination"
    template: _.template(Template)
    events:
      'click #destinationSubmit': "route"

    render: ->
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template()

    route: (e) ->
      @directionService = new google.maps.DirectionsService()
      routeBoxer = new RouteBoxer()
      destination = $("#destination-input").val()
      distance = 5.0

      # TODO: use location API
      request =
        "origin": "Helsinki"
        "destination": destination
        "travelMode": google.maps.DirectionsTravelMode.DRIVING

      console.log request

      @directionService.route(request, (result, status) ->
        if (status == google.maps.DirectionsStatus.OK)
          console.log result
          console.log result.routes[0].overview_path

          # route
          route = new Route(result)
          route.save()

          # locations
          locations = new Locations()

          console.log "locations"
          console.log locations

          boxes = routeBoxer.box(result.routes[0].overview_path, distance)


          for box in boxes
            $.ajax
              url: "/api/v1/pois.json?bbox=#{box}"
              dataType: "json"
              async: false
              success: (json) ->
                if json.length > 0
                  for poi in json
                    location = new Location(poi)
                    locations.add location
                    console.log locations


          console.log "locations"
          console.log locations
          locations.save()


          $.mobile.changePage($("#route"))
        else
          alert "Directions query failed: " + status
      )

  views.destination = new Destination
