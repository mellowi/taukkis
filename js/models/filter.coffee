define [], () ->

  class Filter extends Backbone.Model
    id: "filter"

    addCategoryOut: (category) ->
      categoriesOut = @get("categoriesOut")
      index = $.inArray(category, categoriesOut)
      if index == -1
        categoriesOut.push category
      else
        categoriesOut.splice(index, 1);


    fetch: (options) ->
      json = localStorage.getItem(@id)
      if(json)
        data = JSON.parse(json);
        @set(data);
      else
        @set(categoriesOut: [])


    save: (attributes, options) ->
      localStorage.setItem(@id, JSON.stringify(@attributes));


    destroy: () ->
      localStorage.removeItem(@id);