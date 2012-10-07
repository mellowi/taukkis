define ["text!templates/timeline.html"], (Template) ->

  class Timeline extends Backbone.View

    el: "#app"
    events: {}
    template: _.template(Template)

    render: ->
      $(@el).html @template()

  views.timeline = new Timeline