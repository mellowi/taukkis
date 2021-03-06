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
    events:
      "tap .category-filter": "categories"

    render: (type) ->
      if(utils.route == null || utils.locations == null)
        utils.initFail()
        return

      if type != "poi"
        views.header.render(@el)
      utils.menuSelect("timeline")
      # TODO: update locations times here (everytime when rendered)
      # TODO: filter too old locations here
      locations = new Locations(utils.locations.filterOutCategories())
      locations = new Locations(locations.filterWeatherStations())
      locations = new Locations(locations.sortByDistance())
      $("#" + @el.id + " div[data-role='content']").html(@template(
        locations: locations.toJSON()
      )).trigger("create")

      $("html, body").animate {scrollTop: 80*locations.length }, 1


    categories: (e) ->
      utils.setCategory(e)
      @render("poi")


  views.timeline = new Timeline