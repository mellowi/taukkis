define ["text!templates/header.html"], (Template) ->

  class Header extends Backbone.View

    el: ".header"
    template: _.template(Template)

    render: (e) ->
      $("#" + e.id + " div[data-role='header']").html @template()

  views.header = new Header