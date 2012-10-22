define ["text!templates/detail.html"], (Template) ->

  class Detail extends Backbone.View

    el: "#popup"
    events:
      "click #close": "close"
    template: _.template(Template)

    render: ->
      $("#popup").removeClass("hidden");
      $(@el).html @template()

    close: ->
      $("#popup").addClass("hidden");


  views.detail = new Detail