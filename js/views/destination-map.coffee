define ["cs!views/map", "text!templates/destination-map.html"], (MapView, Template) ->

  views.destinationMap = new (MapView.extend(

    template: _.template(Template)

    # rendering
    render: ->
      console.log(@map);
      $(@el).html @template()

  ))