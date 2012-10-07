define ["cs!views/map", "text!templates/route-map.html"], (MapView, Template) ->

  views.routeMap = new (MapView.extend(

    template: _.template(Template)

    # rendering
    render: ->
      console.log(@map);
      $(@el).html @template()

  ))