class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()
    require ["cs!models/map"], (Map) ->
      utils.map = new Map()
    require ["cs!views/header"], ->
      views.header.render()

  routes:
    "": "destination"
    "destination": "destination"
    "route": "routeMap"
    "timeline": "timeline"
    "category?id=:id": "category"
    "detail?id=:id": "detail"

  destination: ->
    $("body").removeClass().addClass("destination");
    require ["cs!views/destination"], ->
      views.destination.render()

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

utils.app = new Router