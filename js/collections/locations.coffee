define [
  "cs!models/location"
], (Location) ->

  class Locations extends Backbone.Collection
    id: "locations"
    url: "/api/v1/pois.json"
    model: Location


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