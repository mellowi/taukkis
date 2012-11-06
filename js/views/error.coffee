define [
  "text!templates/error.html",
  "cs!views/header"
], (Template) ->

  class Error extends Backbone.View

    el: "#error"
    template: _.template(Template)
    events:
      "tap .category-filter": "categories"

    render: (reason) ->
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template(reason: reason)


    categories: (e) ->
      utils.setCategory(e)


  views.error = new Error