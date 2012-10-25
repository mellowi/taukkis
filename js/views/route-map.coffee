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

      if(utils.route == null || utils.locations == null)
        $.mobile.changePage($("#destination"))
        console.log "lol"

      console.log utils.route
      console.log utils.locations

    render: ->
      views.header.render(@el)
      @updateMap()
      @renderRoute()


    renderRoute: ->
      waypoints = []

      for point in utils.route.attributes.routes[0].overview_path
        position = utils.transformLonLat(point.Za, point.Ya)
        waypoints.push(new OpenLayers.Geometry.Point(position.lon, position.lat))

      routeFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(waypoints), null, utils.routeStyle())

      @clearRoute()
      @showRoute(routeFeature)

      @zoomToExtent(routeFeature.geometry.getBounds())
  ))