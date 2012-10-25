define ["cs!models/map", "cs!views/map", "cs!views/header"], (Map, MapView) ->

  views.routeMap = new (MapView.extend(

    el: "#route"

    render: ->
      views.header.render(@el)
      console.log utils.transformLonLat(2,3)
      @updateMap()

  ))