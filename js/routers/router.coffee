class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()

  routes:
    "": "index"
    "destination": "destination"
    "route": "routeMap"
    "timeline": "timeline"
    "detail?id=:id": "detail"
    "information": "information"
    "category?id=:id": "category"
    "error?reason=:reason": "error"

  index: ->
    if($.mobile.activePage.attr("id") == "empty-page")
      @destination()


  destination: ->
    require ["cs!views/destination"], ->
      $.mobile.changePage($("#destination"), {changeHash:false});
      views.destination.render()


  routeMap: ->
    require ["cs!views/route-map"], ->
      $.mobile.changePage($("#route"), {changeHash:false});
      views.routeMap.render()


  timeline: ->
    require ["cs!views/timeline"], ->
      $.mobile.changePage($("#timeline"), {changeHash:false});
      views.timeline.render()


  detail: (id) ->
    require ["cs!views/detail"], ->
      $.mobile.changePage($("#detail"), {changeHash:false});
      views.detail.render(id)


  information: ->
    require ["cs!views/information"], ->
      $.mobile.changePage($("#information"), {changeHash:false});
      views.information.render()


  error: (reason) ->
    require ["cs!views/error"], ->
      $.mobile.changePage($("#error"), {changeHash:false});
      views.error.render(reason)


utils.app = new Router