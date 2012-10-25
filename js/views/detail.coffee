define ["text!templates/detail.html"], (Template) ->

  class Detail extends Backbone.View

    el: "#popup"
    template: _.template(Template)
    events:
      "click #close": "close"

    render: ->
      $("#popup").removeClass("hidden");
      $(@el).html @template()

    close: ->
      $("#popup").addClass("hidden");


  views.detail = new Detail