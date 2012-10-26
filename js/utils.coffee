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

# <span timer="<time in seconds>"></span>
utils.updateTimer = () ->
  timeNow = new Date().getTime();

  $("[timer]").each (i, el) ->
    timer = parseInt($(el).attr("timer"));
    if (timer < 60*60*24*30)
      timer = timeNow + timer*1000; #microseconds
      $(el).attr("timer", timer);
    timerLeft = parseInt(timer - timeNow); # microseconds left
    if(timerLeft < 0)
      $(el).removeAttr("timer");
      if ($(el).is(':visible')) # event only if element visible
        $(el).trigger("timeEnded")

    # update the shown time
    prevTimeStr = $(el).html();
    curTimeStr = utils.formatTime(timerLeft/1000);
    if(prevTimeStr != curTimeStr)
      $(el).html(curTimeStr)


utils.init = () ->
  return  if utils.initialized
  utils.initialized = true
  # TODO: init single models HERE

  # timer
  utils.updateTimer();
  setInterval (->
    utils.updateTimer()
  ), 5000

      if(utils.filter == null)
        utils.filter = new Filter().fetch()


utils.init()