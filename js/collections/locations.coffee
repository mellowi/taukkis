define [
  "cs!models/location",
  "cs!models/route"
], (Location) ->

  class Locations extends Backbone.Collection
    id: "locations"
    url: "/api/v1/pois.json"
    model: Location
    distance: 5.0

    initialize: () ->
      console.log "luotu"

    fetch: (options) ->
      json = localStorage.getItem(@id)
      if(json)
        data = JSON.parse(json);
        @set(data);


    save: (attributes, options) ->
      localStorage.setItem(@id, JSON.stringify(@));


    destroy: () ->
      localStorage.removeItem(@id);


    sortById: ->
      @sortBy (model) ->
        model.get "id"


    sortByCategory: ->
      @sortBy (model) ->
        model.get "category"


    sortByDistance: ->
      @sortBy (model) ->
        model.get "distance"


    sortByTime: ->
      @sortBy (model) ->
        model.get "distance"


    getById: (id) ->
      @models.filter (model) ->
        return true  if id is model.get("id")
        false


    filterCategory: (category) ->
      @models.filter (model) ->
        return true  if category is model.get("category")
        false


    filterCategories: (categories) ->
      @models.filter (model) ->
        return true  if $.inArray(model.get("category"), categories) > -1
        false