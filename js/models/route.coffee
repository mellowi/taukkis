define [], () ->

  class Route extends Backbone.Model
    id: "route"

    initialize: () ->

    fetch: (options) ->
      json = localStorage.getItem(@id)
      if(json)
        data = JSON.parse(json);
        @set(data);


    save: (attributes, options) ->
      localStorage.setItem(@id, JSON.stringify(@attributes));


    destroy: () ->
      localStorage.removeItem(@id);