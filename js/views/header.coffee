define ["text!templates/header.html", "cs!models/filter"], (Template, Filter) ->

  class Header extends Backbone.View

    el: ".header"
    template: _.template(Template)
    events:
      "tap .category-filter": "categories"

    render: (e) ->
      $("#" + e.id + " div[data-role='header']").html @template()

    categories: (e) ->
      el = $(e.target)
      category = $(el).data("category")
      if(utils.filter == null)
        utils.filter = new Filter().fetch()
      utils.filter.addCategoryOut(category);
      utils.filter.save();

      console.log utils.filter

  views.header = new Header