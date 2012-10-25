define ["cs!models/map", "cs!views/map", "cs!models/route", "cs!views/header"], (Map, MapView, Route) ->

  views.routeMap = new (MapView.extend(

    el: "#route"

    render: ->
      views.header.render(@el)
      @updateMap()
      @renderRoute()

    renderRoute: ->
      waypoints = []

      route = new Route().fetch()

      for point in route.attributes.routes[0].overview_path
        position = utils.transformLonLat(point.Za, point.Ya)
        waypoints.push(new OpenLayers.Geometry.Point(position.lon, position.lat))

      routeFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(waypoints), null, utils.routeStyle())

      @clearRoute()
      @showRoute(routeFeature)

      @zoomToExtent(routeFeature.geometry.getBounds())
  ))