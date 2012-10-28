define [
  "text!templates/error.html",
  "cs!views/header"
], (Template) ->

  class Error extends Backbone.View

    el: "#error"
    template: _.template(Template)

    render: (reason) ->
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template(reason: reason)

  views.error = new Error