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
      content.height viewHeight
      content.width viewWidth


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