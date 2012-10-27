define [
  "text!templates/information.html",
  "cs!views/header"
], (Template) ->

  class Information extends Backbone.View

    el: "#information"
    template: _.template(Template)

    render: ->
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template()

  views.information = new Information