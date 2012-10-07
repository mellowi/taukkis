define ["cs!views/map", "text!templates/route-map.html"], (MapView, Template) ->

  views.routeMap = new (MapView.extend(

    template: _.template(Template)

    # rendering
    render: ->
      $("#map").removeClass("hidden");
      $(@el).html @template()

  ))