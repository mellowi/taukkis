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


    updateMap: (width, height) ->
      @setSize(width, height)
      @setMap()
      @initLayers()


    setMap: ->
      if(utils.map == null)
        utils.map = new Map()
      else
        utils.map.instance.updateSize()


    initLayers: ->
      unless(utils.routeLayer)
        utils.routeLayer = new OpenLayers.Layer.Vector("Route")
        @addLayer(utils.routeLayer)
      unless(utils.poiLayer)
        utils.poiLayer = new OpenLayers.Layer.Vector("POIs", {styleMap: utils.poiStyleMap})
        @addLayer(utils.poiLayer)


    showRoute: (routeFeature) ->
      utils.routeLayer.addFeatures([routeFeature])


    clearRoute: ->
      utils.routeLayer.removeAllFeatures()


    addPOIFeatureToMap: (poiFeature) ->
      utils.poiLayer.addFeatures([poiFeature])


    clearPOILayer: ->
      utils.poiLayer.removeAllFeatures()


    setSize: (width, height) ->
      content = $("#map")
      if(!width || !height)
        height = $(window).height()
        width = $(window).width()
      content.height height-60 #60 header
      content.width width+20 #20 scroller TODO: check with other devices - chrome tested


    addLayer: (layer) ->
      utils.map.instance.addLayer(layer)


    zoomToExtent: (bounds) ->
      utils.map.instance.zoomToExtent(bounds)


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