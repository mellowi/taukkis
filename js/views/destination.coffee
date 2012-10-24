define ["text!templates/destination.html", "cs!models/route", "cs!views/header"], (Template, Route) ->

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

          # saves route to the local storage - ez model style
          route = new Route(result);
          route.save();

          console.log route

          utils.app.navigate('route', true)
        else
          alert "Directions query failed: " + status
      )

  views.destination = new Destination
