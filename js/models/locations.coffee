define ["cs!models/location"], (Location) ->

  class Locations extends Backbone.Collection
  	model: Location
  	id: "locations"

  	save: (attributes, options) ->
      localStorage.setItem(@id, JSON.stringify(@attributes))

	fetch: (options) ->
      json = localStorage.getItem(@id)
      if(json)
        data = JSON.parse(json)
        @set(data)