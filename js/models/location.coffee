define [], () ->

  class Location extends Backbone.Model
    id: "location"

    initialize: ->
      @setDistance(1) # TODO: algorithm to get distance/time to the POI - update the information with interval (5min?)

    setDistance: (distance) ->
      @set distance: distance
