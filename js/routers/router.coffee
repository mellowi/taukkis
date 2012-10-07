class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()
    require ["cs!views/header"], ->
      views.header.render()

  routes:
    "": "destinationMap"
    "destination": "destinationMap"
    "route": "routeMap"
    "timeline": "timeline"

  destinationMap: ->
    require ["cs!views/destination-map"], ->
      views.destinationMap.render()

  routeMap: ->
    require ["cs!views/route-map"], ->
      views.routeMap.render()

  timeline: ->
    require ["cs!views/timeline"], ->
      views.timeline.render()

return new Router