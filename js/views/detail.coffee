define [
  "cs!views/map",
  "text!templates/detail.html",
  "cs!models/route",
  "cs!models/location",
  "cs!collections/locations",
  "cs!views/header"
], (MapView, Template, Route, Location, Locations) ->

  views.detail = new (MapView.extend(

    el: "#detail"
    template: _.template(Template)
    events:
      "click #close": "close"

    initialize: ->
      if(utils.route == null)
        utils.route = new Route().fetch()
      if(utils.locations == null)
        utils.locations = new Locations().fetch()

      if(_.isUndefined(utils.route) || _.isUndefined(utils.locations))
        $.mobile.changePage($("#destination"))
        utils.app.navigate("#destination", true, true)
      return


    render: (id) ->
      views.header.render(@el)
      location = new Locations(utils.locations.getById(id)).models[0]
      # TODO: update location time here (everytime when rendered)
      @updateMap(300, 100)
      $("#" + @el.id + " div[data-role='content']").html @template(
        location: location.toJSON()
      )


    close: ->
      $("#popup").addClass("hidden");


  ))