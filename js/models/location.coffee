define [], () ->

  class Location extends Backbone.Model
    id: "location"

    initialize: ->
      @setDistance(1) # TODO: algorithm to get distance/time to the POI - update the information with interval (5min?)
      @setTime(60*60) # seconds or what?


    setDistance: (distance) ->
      @set distance: distance


    setTime: (time) ->
      @set time: time