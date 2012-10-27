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


  information: ->
    require ["cs!views/information"], ->
      views.information.render()
      $.mobile.changePage($("#information"), {changeHash:false});


utils.app = new Router