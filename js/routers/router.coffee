class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()
    require ["cs!models/map"], (Map) ->
      utils.map = new Map()
    require ["cs!views/header"], ->
      views.header.render()

  routes:
    "": "destinationMap"
    "destination": "destinationMap"
    "route": "routeMap"
    "timeline": "timeline"
    "category?id=:id": "category"
    "detail?id=:id": "detail"

  destinationMap: ->
    $("body").removeClass().addClass("destination");
    require ["cs!views/destination-map"], ->
      views.destinationMap.render()

  routeMap: ->
    $("body").removeClass().addClass("route");
    require ["cs!views/route-map"], ->
      views.routeMap.render()

  timeline: ->
    $("body").removeClass().addClass("timeline");
    require ["cs!views/timeline"], ->
      views.timeline.render()

  category: (id) ->
    # TODO: some kind of category list (toggle with this id select)
    console.log(id);
    
  detail: (id) ->
    require ["cs!views/detail"], ->
      views.detail.render(id)
    
return new Router