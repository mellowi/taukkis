utils.transformLonLat = (lon, lat) ->
  lonLat = new OpenLayers.LonLat(lon, lat)
  lonLat = lonLat.transform(new OpenLayers.Projection(defaults.projection2), new OpenLayers.Projection(defaults.projection))
  return lonLat

utils.routeStyle = () ->
  routeStyle = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default'])
  routeStyle.strokeColor = "blue"
  routeStyle.strokeWidth = 5
  return routeStyle

utils.poiStyleMap = new OpenLayers.StyleMap({
							"default":new OpenLayers.Style(OpenLayers.Util.applyDefaults({
              externalGraphic:"/img/taukkis-marker.png"
              graphicOpacity:1
              pointRadius: 14
              }
              OpenLayers.Feature.Vector.style["default"]))
              })
