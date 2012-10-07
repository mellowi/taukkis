define ["cs!models/map"], (Map) ->

  Backbone.View.extend

    el: "#app"
    events:
      "click #plus": "zoomIn"
      "click #minus": "zoomOut"
      "click #up": "moveUp"
      "click #down": "moveDown"
      "click #left": "moveLeft"
      "click #right": "moveRight"
    map: utils.map

    # event handler
    zoomIn: ->
      @map.zoomIn()


    zoomOut: ->
      @map.zoomOut()


    moveUp: ->
      @map.pan(0, -256)


    moveDown: ->
      @map.pan(0, 256)


    moveLeft: ->
      @map.pan(-256, 0)


    moveRight: ->
      @map.pan(256, 0)