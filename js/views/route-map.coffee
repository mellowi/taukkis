define ["cs!models/map", "cs!views/map", "cs!views/header"], (Map, MapView) ->

  views.routeMap = new (MapView.extend(

    el: "#route"

    render: ->
      views.header.render(@el)
      $("#map").ready ->
        utils.map = new Map()

  ))