define ["text!templates/header.html"], (Template) ->

  class Header extends Backbone.View

    el: ".header"
    template: _.template(Template)

    render: (e) ->
      $("#" + e.id + " div[data-role='header']").html @template()
      @initCategories()


    initCategories: ->
      nav = $(".nav")
      for category in utils.filter.get("categoriesOut")
        nav.find("a[data-category='" + category + "']").addClass("out")

  views.header = new Header