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
    map: null
    mapInstance: null

    # constructor
    initialize: ->
      @init()

    init: ->
      @map = new Map()
      @mapInstance = @map.getInstance()

    # rendering
    render: ->
      $(@el).html @template()


    # event handler
    zoomIn: ->
      @mapInstance.zoomIn()


    zoomOut: ->
      @mapInstance.zoomOut()


    moveUp: ->
      @mapInstance.pan(0, -256)


    moveDown: ->
      @mapInstance.pan(0, 256)


    moveLeft: ->
      @mapInstance.pan(-256, 0)


    moveRight: ->
      @mapInstance.pan(256, 0)