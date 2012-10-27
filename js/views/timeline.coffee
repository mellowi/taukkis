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

    render: ->
      if(utils.route == null || utils.locations == null)
        utils.initFail()
        return

      views.header.render(@el)
      # TODO: update locations times here (everytime when rendered)
      # TODO: filter too old locations here
      locations = new Locations(utils.locations.filterOutCategories())
      locations = new Locations(locations.sortByTime())
      $("#" + @el.id + " div[data-role='content']").html @template(
        locations: locations.toJSON()
      )
      # TODO: automaticly scroll the passed locations over..
      # count how many * height => scroll (if some scroll command works)
      # $(window).scrollTop(300);

  views.timeline = new Timeline