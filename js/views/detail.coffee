define [
  "cs!models/map",
  "cs!views/map",
  "text!templates/detail.html",
  "cs!models/route",
  "cs!models/location",
  "cs!collections/locations",
  "cs!views/header"
], (Map, MapView, Template, Route, Location, Locations) ->

  views.detail = new (MapView.extend(

    el: "#detail"
    template: _.template(Template)
    events:
      "click #close": "close"
    mapElement: "detail-map"

    initialize: ->
      if(utils.route == null)
        utils.route = new Route().fetch()
      if(utils.locations == null)
        utils.locations = new Locations().fetch()

      if(_.isUndefined(utils.route) || _.isUndefined(utils.locations))
        $.mobile.changePage($("#destination"))
        utils.app.navigate("#destination", true, true)
        utils.route = null
        utils.locations = null
      return


    render: (id) ->
      views.header.render(@el)

      @poi = new Locations(utils.locations.getById(id)).models[0].toJSON()
      # TODO: update location time here (everytime when rendered)
      $("#" + @el.id + " div[data-role='content']").html @template(
        location: @poi
      )

      @updateMap(500, 300)
      @clearRoute()
      @clearPOILayer()
      @renderPoi()


    setMap: ->
      utils.detailMap = new Map(@mapElement)

    addLayer: (layer) ->
      utils.detailMap.instance.addLayer(layer)

    renderPoi: ->
      position = utils.transformLonLat(@poi.lon, @poi.lat)
      poiFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      poiFeature.attributes = @poi
      console.log @poi
      console.log poiFeature
      utils.poiLayer.addFeatures([poiFeature])

    close: ->
      $("#popup").addClass("hidden");


  ))