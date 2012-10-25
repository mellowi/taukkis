define [
  "text!templates/timeline.html",
  "cs!models/route",
  "cs!models/location",
  "cs!collections/locations",
  "cs!views/header"
], (Template, Route, Location, Locations) ->

  class Timeline extends Backbone.View

    el: "#timeline"
    template: _.template(Template)

    initialize: ->
      if(utils.route == null)
        utils.route = new Route().fetch()
      if(utils.locations == null)
        utils.locations = new Locations().fetch()

      if(_.isUndefined(utils.route) || _.isUndefined(utils.locations))
        $.mobile.changePage($("#destination"))
        utils.app.navigate("#destination", true, true)
      return


    render: ->
      views.header.render(@el)
      console.log(utils.locations)
      $("#" + @el.id + " div[data-role='content']").html @template()

  views.timeline = new Timeline