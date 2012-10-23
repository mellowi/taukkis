define ["text!templates/destination_selection.html", "cs!models/route"], (Template) ->

  class DestinationSelection extends Backbone.View
    parent: "#destinationSelection"
    template: _.template(Template)

    render: ->
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

          # TODO: tallenna reitti johonkin ?!

          utils.app.navigate('route', true)
        else
          alert "Directions query failed: " + status
      )

  views.destinationSelection = new DestinationSelection
