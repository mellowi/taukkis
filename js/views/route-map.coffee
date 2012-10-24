define ["cs!views/map"], (MapView) ->

  views.routeMap = new (MapView.extend(
    render: ->
      $("#map").removeClass("hidden");
      $(@el).html()
  ))