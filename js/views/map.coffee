define ["cs!models/map", "text!templates/home.html"], (Map, Template) ->

  class MapView extends Backbone.View

    el: "#app"
    template: _.template(Template)
    events:
#      "click #locate": "mapClick"
#      "change #lolnasLayer": "lolnasChange"
#      "change #alkoLayer": "alkoChange"
#      "change #mapSelect": "mapChange"
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

  views.map = new MapView