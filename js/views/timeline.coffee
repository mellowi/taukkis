define ["text!templates/timeline.html"], (Template) ->

  class Timeline extends Backbone.View

    el: "#app"
    template: _.template(Template)

    render: ->
      $("#map").addClass("hidden");
      $(@el).html @template()

    mapToggle: ->
      $("#map").addClass("hidden");

  views.timeline = new Timeline