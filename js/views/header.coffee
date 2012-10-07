define ["text!templates/header.html"], (Template) ->

  class Header extends Backbone.View

    el: ".header"
    template: _.template(Template)

    render: ->
      $(@el).html @template()

  views.header = new Header