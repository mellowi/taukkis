define ["text!templates/destination.html", "cs!models/route"], (Template, Route) ->

  class Destination extends Backbone.View
    el: "#app"
    template: _.template(Template)
    events:
      'click #destinationSubmit': "route"

    render: ->
      $(@el).html @template()
      $(@el).removeClass("hidden");
      $("#map").addClass("hidden");

    route: (e) ->
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

          console.log result
          console.log result.routes[0].overview_path
          route = new Route(result);
          console.log route
          route.save();

          # TODO: tallenna reitti johonkin ?!

          utils.app.navigate('route', true)
        else
          alert "Directions query failed: " + status
      )

  views.destination = new Destination
