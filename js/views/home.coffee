define ["cs!models/model", "text!templates/home.html"], (Model, Template) ->

  class Home extends Backbone.View

    el: "#content"
    template: _.template(Template)
    events: {}
    
    # constructor
    initialize: ->
      @model = new Model()

    render: ->
      $(@el).html @template(model: @model.toJSON())

  views.home = new Home