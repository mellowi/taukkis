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
      $("#" + @el.id + " div[data-role='content']").html @template()


    categories: (e) ->
      utils.setCategory(e)


  views.information = new Information