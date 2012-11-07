define ["cs!models/route"], (Route) ->

  class Location extends Backbone.Model
    id: "location"

    initialize: ->
      @update()
      @initWeather() if $.inArray("weather_station", @get("categories")) > -1


    # http://www.infotripla.fi/digitraffic/docs/Meta_RWS_sensors.pdf
    initWeather: ->
      console.log @get("municipality")
      #console.log weatherCodes[@get("precipitation")]
      #console.log weatherCodes[@get("precipitationtype")]
      #console.log weatherRoadCodes[@get("roadsurfaceconditions1")]
      #console.log weatherRoadCodes[@get("roadsurfaceconditions2")]
      #console.log weatherWarningCodes[@get("warning1")]
      #console.log weatherWarningCodes[@get("warning2")]


    update: ->
      if(utils.currentLocation != null)
        @setDistance(@calculateDistance())
        @setTime(@calculateTime())


    calculateDistance: ->
      R = 6371; # km
      lon1 = utils.currentLocation.lon
      lat1 = utils.currentLocation.lat
      lon2 = this.attributes.lon
      lat2 = this.attributes.lat
      dLat = (lat2-lat1).toRad()
      dLon = (lon2-lon1).toRad()
      lat1 = lat1.toRad()
      lat2 = lat2.toRad()

      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      return R * c


    calculateTime: ->
      lolfactor = 1.15
      @get("distance")*1000 / utils.route.get("averageSpeed") * lolfactor


    setDistance: (distance) ->
      @set distance: distance


    setTime: (time) ->
      @set time: time