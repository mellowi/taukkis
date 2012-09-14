class Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()
    require ["cs!views/header"], ->
      views.header.render()

  routes:
    "": "home"
    home: "home"

  home: ->
    require ["cs!views/home"], ->
      views.home.render()

return new Router