define [
  "cs!models/map",
  "cs!views/map",
  "cs!models/location",
  "cs!collections/locations",
  "cs!models/route",
  "cs!views/header"
], (Map, MapView, Location, Locations, Route) ->

  views.routeMap = new (MapView.extend(

    el: "#route"

    render: ->
      if(utils.route == null || utils.locations == null)
        utils.initFail()
        return

      views.header.render(@el)
      @updateMap()
      @clearRoute()
      @clearPOILayer()
      @addStartAndEndPoints()
      @renderRoute()
      @renderPois()


    renderRoute: ->
      waypoints = []

      for point in utils.route.attributes.routes[0].overview_path
        position = utils.transformLonLat(point.Za, point.Ya)
        waypoints.push(new OpenLayers.Geometry.Point(position.lon, position.lat))

      routeFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(waypoints), null, utils.routeStyle())

      @showRoute(routeFeature)

      @zoomToExtent(routeFeature.geometry.getBounds())

    renderPois: ->
      pois = new Locations().fetch()
      pois.each (poi) ->
        position = utils.transformLonLat(poi.attributes.lon, poi.attributes.lat)
        poiFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
        poiFeature.attributes = poi.attributes
        utils.poiLayer.addFeatures([poiFeature])

    addStartAndEndPoints: ->
      route = utils.route.attributes.routes[0].overview_path
      position = utils.transformLonLat(route[0].Za, route[0].Ya)
      startPointFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      startPointFeature.attributes = { type: "start-point" }
      utils.poiLayer.addFeatures([startPointFeature])
      position = utils.transformLonLat(route[-1..][0].Za, route[-1..][0].Ya)
      endPointFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      endPointFeature.attributes = { type: "end-point" }
      utils.poiLayer.addFeatures([endPointFeature])

  ))