define ["text!templates/destination.html", "cs!models/route", "cs!models/location", "cs!models/locations", "cs!views/header"], (Template, Route, Location, Locations) ->

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
        console.log "in cb"
        if (status == google.maps.DirectionsStatus.OK)

          console.log "got ok"

          console.log result
          console.log result.routes[0].overview_path

          # saves route to the local storage - ez model style
          route = new Route(result)
          route.save()

          locations = new Locations()

          boxes = routeBoxer.box(result.routes[0].overview_path, distance)

          for box in boxes
            $.getJSON("/api/v1/pois.json?bbox=#{box}", (json) ->
               if json.length > 0
                for poi in json
                  console.log("lol")
                  locations.push(new Location(poi))
            )

          locations.save()

          utils.app.navigate('route', true)
        else
          alert "Directions query failed: " + status
      )

  views.destination = new Destination
