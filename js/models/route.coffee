define [], () ->

  class Route extends Backbone.Model

    fetch: (options) ->
      json = localStorage.getItem("route")
      if(json)
        data = JSON.parse(json);
        @set(data);

    save: (attributes, options) ->
      localStorage.setItem("route", JSON.stringify(@attributes));


    destroy: () ->
      localStorage.removeItem("route");