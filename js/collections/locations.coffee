define [
  "cs!models/location",
  "cs!models/filter"
], (Location, Filter) ->

  class Locations extends Backbone.Collection
    id: "locations"
    model: Location

    updateAll: ->
      for location in @models
        location.update()


    fetch: (options) ->
      json = localStorage.getItem(@id)
      if(json)
        data = JSON.parse(json);
        @add(data);


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
        -model.get "distance"


    sortByTime: ->
      @sortBy (model) ->
        -model.get "time"


    getById: (id) ->
      @models.filter (model) ->
        return true  if parseInt(id) is model.get("id")
        return true  if id is model.get("id")
        false

    filterWeatherStations: () ->
      # get the first of the municipality
      @models.filter (model) =>
        return true if model.get("categories")[0] != "weather_station"
        matches = @where(
          municipality: model.get("municipality")
        )
        return true if (matches.length == 1)

        if (matches.length > 1)
          select = null
          warning = 0
          $.each matches, (i, match) -> # get highest warning num
            if(warning < match.get("warning1"))
              warning = match.get("warning1")
              select = i
          return true if (!select && model.cid == matches[0]["cid"])
          return true if (select && model.cid == matches[select]["cid"])

        return false

    filterCategory: (category) ->
      @models.filter (model) ->
        if(!_.isUndefined(model.get("category")) && !$.isArray(model.get("category")))
          return true  if category is model.get("category")
          false
        else
          return true  if $.inArray(category, model.get("categories")) > -1
          false


    filterCategories: (categories) ->
      @models.filter (model) ->
        if(!_.isUndefined(model.get("category"))  && !$.isArray(model.get("category")))
          return true  if $.inArray(model.get("category"), categories) > -1
          false
        else
          for category in model.get("categories")
            return true  if $.inArray(category, categories) > -1
          false


    filterOutCategory: (category) ->
      @models.filter (model) ->
        if(!_.isUndefined(model.get("category"))  && !$.isArray(model.get("category")))
          return false  if category is model.get("category")
          true
        else
          return true  if $.inArray(category, model.get("categories")) == -1
          false


    filterOutCategories: () ->
      @models.filter (model) ->
        if(!_.isUndefined(model.get("category"))  && !$.isArray(model.get("category")))
          return false  if $.inArray(model.get("category"), utils.filter.get("categoriesOut")) > -1
          true
        else # if all of the model's categories are filteredOut return false
          for category in model.get("categories")
            return true  if $.inArray(category, utils.filter.get("categoriesOut")) == -1
          false
