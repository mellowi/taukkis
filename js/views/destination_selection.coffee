define ["text!templates/destination_selection.html", "cs!models/directions"], (Template) ->

  class DestinationSelection extends Backbone.View
    parent: "#destinationSelection"
    template: _.template(Template)

    render: ->
      # $("#map").addClass("hidden");
      $(@parent).html @template()
      $(@parent).removeClass("hidden");
      $("#map").addClass("hidden");
      $("#destinationSubmit").click(@route)

    route: (destination) ->
      @directionService = new google.maps.DirectionsService()
      destination = $("#destination").val()
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

          console.log result.routes[0].overview_path
          # directionsRenderer.setDirections(result);

          # // Box around the overview path of the first route
          # var path = result.routes[0].overview_path;
          # var boxes = routeBoxer.box(path, distance);
          # drawMarkers(boxes);
          # drawBoxes(boxes);
        else
          alert "Directions query failed: " + status
      )

  views.destinationSelection = new DestinationSelection
