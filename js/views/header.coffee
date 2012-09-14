define ["text!templates/header.html"], (Template) ->

  class Header extends Backbone.View

    el: ".header"
    template: _.template(Template)
    events: {}
    
    # constructor
    initialize: ->

    render: ->
      $(@el).html @template()

    selectMenuItem: (menuItem) ->
      $(".nav li").removeClass "active"
      $("." + menuItem).addClass "active" if menuItem


  views.header = new Header