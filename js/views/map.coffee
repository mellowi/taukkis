define [
  "text!templates/map-tooltip.html",
  "cs!models/map"
], (TooltipTemplate, Map) ->

  Backbone.View.extend

    tooltipTemplate: _.template(TooltipTemplate)
    events:
      "resize pageshow": "updateSize"
      "tap .category-filter": "categories"
      "pagehide": "removeTooltips"
      "tap a": "removeTooltips"

    mapElement: "map"
    routeLayer: null
    poiLayer: null

    initialize: ->
      $(window).bind("resize.app", _.bind(@updateSize, @))


    remove: ->
      $(window).unbind("resize.app");


    updateSize: ->
      @setSize()
      if(@mapElement == "map")
        utils.map.instance.updateSize()
      else
        utils.detailMap.instance.updateSize()


    updateMap: () ->
      @setSize()
      @setMap()
      @initLayers()


    categories: (e) ->
      utils.setCategory(e)
      @render("poi")


    removeTooltips: ->
      if(@mapElement == "map" && utils.map != null)
        utils.map.removeTooltips()


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
      @addLayer(utils.geoLocateLayer)

      # refactor to own models? select-control.coffee & highlight-control.coffee
      if(@mapElement == "map")
        selectControl = new OpenLayers.Control.SelectFeature(
          @poiLayer,
          {
            id: 'poi-select-control'
          }
        )
        selectControl.onSelect = (feature) =>
          @showPOIDetails(feature)
        utils.map.instance.addControl(selectControl)
        selectControl.activate()


    showPOIDetails: (feature) ->
      poi = feature.attributes

      $(".qtip").remove()
      position = $("#" + feature.geometry.id).offset() # position()
      $("#" + feature.geometry.id).qtip(
        position:
          my: 'bottom center'
          at: 'top center'
          target: [position.left+12, position.top] #left addition because of the poi:s are misplaced
          viewport: $(window)
        content: @tooltipTemplate(location: poi)
        show:
          when: false
          ready: true
        hide: false # Don't specify a hide event
        style:
          classes: 'ui-tooltip ui-tooltip-green ui-tooltip-rounded ui-tooltip-shadow'
          tip: true
      )


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


    setSize: () ->
      content = $("#"+@mapElement)
      if(@mapElement == "map")
        width = $(window).width()
        #height = $(window).height() - 53
        height = (if window.innerHeight then window.innerHeight else $(window).height())
        height = height - 53 #banner height
        if(utils.map)
          utils.map.instance.div.style.width = width

          utils.map.instance.div.style.height = height
      else if(@mapElement == "detail-map")
        width = $(window).width() - 40
        height = width / 3
        if(utils.detailMap)
          utils.detailMap.instance.div.style.width = width
          utils.detailMap.instance.div.style.height = height
      content.height height
      content.width width


    addLayer: (layer) ->
      if(@mapElement == "map")
        utils.map.instance.addLayer(layer)
      else
        utils.detailMap.instance.addLayer(layer)


    zoomToExtent: (bounds) ->
      utils.map.instance.zoomToExtent(bounds)