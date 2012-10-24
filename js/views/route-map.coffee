define ["cs!models/map", "cs!views/map", "cs!views/header"], (Map, MapView) ->

  views.routeMap = new (MapView.extend(

    el: "#route"

    render: ->
      views.header.render(@el)

      @setMapSize()

      if(utils.map == null)
        utils.map = new Map()
      else
      	utils.map.instance.updateSize()


    setMapSize: ->
      content = $("#map")
      viewHeight = $(window).height()
      viewWidth = $(window).width()
      content.height viewHeight
      content.width viewWidth
      
  ))