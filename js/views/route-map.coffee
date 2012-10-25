define ["cs!models/map", "cs!views/map", "cs!views/header"], (Map, MapView) ->

  views.routeMap = new (MapView.extend(

    el: "#route"

    render: ->
      views.header.render(@el)
      @updateMap()

      routeLayer = new OpenLayers.Layer.Vector("asdf")

      routeStyle = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default'])
      routeStyle.strokeColor = "blue"
      routeStyle.strokeWidth = 3

      waypoints = []
      position = utils.transformLonLat(24.985428, 60.291577)
      point = new OpenLayers.Geometry.Point(position.lon, position.lat)
      position = utils.transformLonLat(25.655594, 60.979770)
      point2 = new OpenLayers.Geometry.Point(position.lon, position.lat)
      waypoints.push(point)
      waypoints.push(point2)

      routeFeature = OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(waypoints), null)#, routeStyle)
      @addLayer(routeLayer)
      routeLayer.addFeatures([routeFeature])


  ))