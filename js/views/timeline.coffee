define ["text!templates/timeline.html", "cs!views/header"], (Template) ->

  class Timeline extends Backbone.View

    el: "#timeline"
    template: _.template(Template)

    render: ->
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template()

  views.timeline = new Timeline