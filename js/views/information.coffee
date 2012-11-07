define [
  "text!templates/information.html",
  "cs!views/header"
], (Template) ->

  class Information extends Backbone.View

    el: "#information"
    template: _.template(Template)
    events:
      "tap .category-filter": "categories"

    render: ->
      views.header.render(@el)
      utils.menuSelect("information")
      $("#" + @el.id + " div[data-role='content']").html(@template()).trigger("create")


    categories: (e) ->
      utils.setCategory(e)


  views.information = new Information