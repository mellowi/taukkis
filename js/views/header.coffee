define ["text!templates/header.html"], (Template) ->

  class Header extends Backbone.View

    el: ".header"
    template: _.template(Template)
    events:
      "tap #locate": "locate"

    render: (e) ->
      $("#" + e.id + " div[data-role='header']").html @template()
      @initCategories()


    initCategories: ->
      nav = $(".nav")
      for category in utils.filter.get("categoriesOut")
        nav.find("a[data-category='" + category + "']").addClass("out")


    locate: ->
      if(utils.destinationMap != null)
        control = utils.destinationMap.instance.getControlsBy("id", "locate-control")[0];
      else
        control = utils.map.instance.getControlsBy("id", "locate-control")[0];
      if (control.active)
          control.getCurrentLocation()
      else
          control.activate()

  views.header = new Header