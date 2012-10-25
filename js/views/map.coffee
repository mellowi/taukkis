define ["cs!models/map"], (Map) ->

  Backbone.View.extend

    events:
      "click #plus": "zoomIn"
      "click #minus": "zoomOut"
      "click #up": "moveUp"
      "click #down": "moveDown"
      "click #left": "moveLeft"
      "click #right": "moveRight"
      "orientationchange resize pageshow": "updateMap"


    updateMap: ->
      @setSize()
      @setMap()


    setMap: ->
      if(utils.map == null)
        utils.map = new Map()
      else
        utils.map.instance.updateSize()


    setSize: ->
      content = $("#map")
      viewHeight = $(window).height()
      viewWidth = $(window).width()
      content.height viewHeight-60 #60 header
      content.width viewWidth+20 #20 scroller TODO: check with other devices - chrome tested


    addLayer: (layer) ->
      utils.map.instance.addLayer(layer)

    zoomIn: ->
      utils.map.zoomIn()


    zoomOut: ->
      utils.map.zoomOut()


    moveUp: ->
      utils.map.pan(0, -256)


    moveDown: ->
      utils.map.pan(0, 256)


    moveLeft: ->
      utils.map.pan(-256, 0)


    moveRight: ->
      utils.map.pan(256, 0)