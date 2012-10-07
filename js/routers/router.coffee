class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()
    require ["cs!views/header"], ->
      views.header.render()

  routes:
    "": "destination",
    "destination": "destination",
    "route": "route",
    "timeline": "timeline"

  destination: ->
    require ["cs!views/destination-map"], ->
      views.destinationMap.render()

  route: ->
    require ["cs!views/route"], ->
      views.route.render()

  timeline: ->
    require ["cs!views/timeline-map"], ->
      views.timelineMap.render()

return new Router