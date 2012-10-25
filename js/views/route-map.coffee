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

    initialize: ->
      if(utils.route == null)
        utils.route = new Route().fetch()
      if(utils.locations == null)
        utils.locations = new Locations().fetch()

      if(_.isUndefined(utils.route) || _.isUndefined(utils.locations))
        $.mobile.changePage($("#destination"))
        utils.app.navigate("#destination", true, true)
      return


    render: ->
      views.header.render(@el)
      @updateMap()
      @clearRoute()
      @clearPOIs()
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
        utils.poiLayer.addFeatures([poiFeature])

  ))