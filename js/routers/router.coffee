class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()

  routes:
    "": "index"
    "destination": "destination"
    "route": "routeMap"
    "timeline": "timeline"
    "category?id=:id": "category"
    "detail?id=:id": "detail"

  index: ->
    if($.mobile.activePage.attr("id") == "destination")
      @destination()


  destination: ->
    require ["cs!views/destination"], ->
      views.destination.render()
      $.mobile.changePage($("#destination"), {changeHash:false});


  routeMap: ->
    require ["cs!views/route-map"], ->
      views.routeMap.render()
      $.mobile.changePage($("#route"), {changeHash:false});


  timeline: ->
    require ["cs!views/timeline"], ->
      views.timeline.render()
      $.mobile.changePage($("#timeline"), {changeHash:false});


  detail: (id) ->
    require ["cs!views/detail"], ->
      views.detail.render(id)
      $.mobile.changePage($("#detail"), {changeHash:false});


utils.app = new Router