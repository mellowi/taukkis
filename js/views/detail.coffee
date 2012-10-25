define ["cs!views/map", "text!templates/detail.html", "cs!views/header"], (MapView, Template) ->

  views.detail = new (MapView.extend(

    el: "#detail"
    template: _.template(Template)
    events:
      "click #close": "close"

    template: _.template(Template)

    render: (id) ->
      views.header.render(@el)
      $("#" + @el.id + " div[data-role='content']").html @template()
      @updateMap(300, 100)

    close: ->
      $("#popup").addClass("hidden");


  ))