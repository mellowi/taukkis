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
      "tap .category-filter": "categories"

    mapElement: "map"
    routeLayer: null
    poiLayer: null

    updateMap: (width, height) ->
      @setSize(width, height)
      @setMap()
      @initLayers()


    categories: (e) ->
      utils.setCategory(e)
      @render()


    setMap: ->
      if(@mapElement == "map")
        if(utils.map == null)
          utils.map = new Map(@mapElement)
        else
          utils.map.instance.updateSize()
      else
        utils.detailMap = new Map(@mapElement)

    initLayers: ->
      if(@routeLayer and @mapElement == "map")
        utils.map.instance.removeLayer(@routeLayer)
      @routeLayer = new OpenLayers.Layer.Vector("Route")
      @addLayer(@routeLayer)

      if(@poiLayer and @mapElement == "map")
        utils.map.instance.removeLayer(@poiLayer)
      @poiLayer = new OpenLayers.Layer.Vector("POIs", {styleMap: utils.poiStyleMap})

      @addLayer(@poiLayer)

      if(@mapElement == "map")
        selectControl = new OpenLayers.Control.SelectFeature(
                @poiLayer,
                {
                  id: 'poi-select-control'
                  onSelect: @showPOIDetails
                }
                )
        utils.map.instance.addControl(selectControl)
        selectControl.activate()

      @addLayer(utils.geoLocateLayer)


    showPOIDetails: (poi) ->
      poi = poi.attributes
      if(!_.isUndefined(poi.id))
        utils.app.navigate("#detail?id="+poi.id, true)
      return


    showRoute: (routeFeature) ->
      @routeLayer.addFeatures([routeFeature])


    renderRoute: (zoomToRoute=false) ->
      waypoints = []
      for point in utils.route.attributes.routes[0].overview_path
        position = utils.transformLonLat(point.Za, point.Ya)
        waypoints.push(new OpenLayers.Geometry.Point(position.lon, position.lat))

      routeFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(waypoints), null, utils.routeStyle())

      @routeLayer.addFeatures([routeFeature])
      if(zoomToRoute)
        @zoomToExtent(routeFeature.geometry.getBounds())


    clearRoute: ->
      @routeLayer.removeAllFeatures()


    addPOIFeatureToMap: (poiFeature) ->
      @poiLayer.addFeatures([poiFeature])


    clearPOILayer: ->
      @poiLayer.removeAllFeatures()


    setSize: (width, height) ->
      content = $("#"+@mapElement)
      if(@mapElement == "map")
        if(!width || !height)
          height = $(window).height()
          width = $(window).width()
      else
        if(!width || !height)
          height = $("#"+@mapElement).height()
          width = $("#"+@mapElement).width()
      content.height height
      content.width width


    addLayer: (layer) ->
      if(@mapElement == "map")
        utils.map.instance.addLayer(layer)
      else
        utils.detailMap.instance.addLayer(layer)


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