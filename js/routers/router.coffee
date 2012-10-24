class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()
  routes:
    "": "destination"
    "destination": "destination"
    "route": "routeMap"
    "timeline": "timeline"
    "category?id=:id": "category"
    "detail?id=:id": "detail"

  destination: ->
    require ["cs!views/destination"], ->
      views.destination.render()

  routeMap: ->
    require ["cs!views/route-map"], ->
      views.routeMap.render()

  timeline: ->
    require ["cs!views/timeline"], ->
      views.timeline.render()

  category: (id) ->
    # TODO: some kind of category list (toggle with this id select)
    console.log(id);

  detail: (id) ->
    require ["cs!views/detail"], ->
      views.detail.render(id)

utils.app = new Router