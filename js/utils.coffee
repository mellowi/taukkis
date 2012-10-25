utils.transformLonLat = (lon, lat) ->
  lonLat = new OpenLayers.LonLat(lon, lat)
  lonLat = lonLat.transform(new OpenLayers.Projection(defaults.projection2), new OpenLayers.Projection(defaults.projection))
  return lonLat

utils.routeStyle = () ->
  routeStyle = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default'])
  routeStyle.strokeColor = "blue"
  routeStyle.strokeWidth = 5
  return routeStyle

context = {
  getIconName: (feature) ->
  	if feature.attributes.type
  		"#{feature.attributes.type}-marker"
  	else
	    "taukkis-marker"
  getLabel: (feature) ->
    if feature.layer.map.getZoom() > 12 and feature.attributes.title
    	feature.attributes.title
    else
      ""
  }

defaultStyle = new OpenLayers.Style(
                {
                externalGraphic:"img/${getIconName}.png"
                graphicOpacity:1
                pointRadius: 14
                label: "${getLabel}"
                labelSelect: "true"
                # TBCSS'd:
                labelAlign: 'cb'
                labelYOffset: 14
                fontFamily: "Helvetica,Arial,sans-serif"
                fontColor: "#222222"
                labelOutlineColor: "white"
                labelOutlineWidth: 3
                }
                {context: context}
                )

utils.poiStyleMap = new OpenLayers.StyleMap("default": defaultStyle)

utils.formatTime = (seconds) ->
  options = options or {}
  formattedTime = ""
  minutes = Math.floor((seconds / 60) % 60)
  hours = Math.floor(seconds / (60 * 60))

  formattedTime += hours + "h "  if hours >= 1
  formattedTime += minutes + "min" if minutes >= 1
  return formattedTime