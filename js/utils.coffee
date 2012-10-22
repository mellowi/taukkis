transformLonLat = (lon, lat) ->
  lonLat = new OpenLayers.LonLat(lon, lat)
  lonLat = lonLat.transform(new OpenLayers.Projection(defaults.projection2), new OpenLayers.Projection(defaults.projection))
  return lonLat