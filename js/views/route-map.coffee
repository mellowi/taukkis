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
    rendered: false

    render: (type) ->
      if(utils.route == null || utils.locations == null)
        utils.initFail()
        return

      if type != "poi"
        views.header.render(@el)

      @updateMap()
      @clearRoute()
      @clearPOILayer()
      @addStartAndEndPoints()
      if(@rendered)
        @renderRoute(false)
      else
        @rendered = true;
        @renderRoute(true)
      @renderPois()


    renderPois: ->
      pois = new Locations(utils.locations.filterOutCategory("weather_station"))
      pois = new Locations(pois.filterOutCategories())
      pois.each (poi) =>
        position = utils.transformLonLat(poi.attributes.lon, poi.attributes.lat)
        poiFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
        poiFeature.attributes = poi.attributes
        @poiLayer.addFeatures([poiFeature])


    addStartAndEndPoints: ->
      route = utils.route.attributes.routes[0].overview_path
      position = utils.transformLonLat(route[0].Za, route[0].Ya)
      startPointFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      startPointFeature.attributes = { type: "start-point" }
      @poiLayer.addFeatures([startPointFeature])
      position = utils.transformLonLat(route[-1..][0].Za, route[-1..][0].Ya)
      endPointFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      endPointFeature.attributes = { type: "end-point" }
      @poiLayer.addFeatures([endPointFeature])

  ))