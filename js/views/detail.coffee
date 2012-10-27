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

    render: (id) ->
      if(utils.route == null || utils.locations == null)
        utils.initFail()
        return

      views.header.render(@el)

      @poi = new Locations(utils.locations.getById(id)).models[0].toJSON()
      # TODO: update location time here (everytime when rendered)
      $("#" + @el.id + " div[data-role='content']").html @template(
        location: @poi
      )

      @updateMap(500, 300)
      @clearRoute()
      @clearPOILayer()
      @renderRoute()
      @renderPoi()


    renderPoi: ->
      position = utils.transformLonLat(@poi.lon, @poi.lat)
      poiFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      poiFeature.attributes = @poi
      console.log @poi
      console.log poiFeature
      @poiLayer.addFeatures([poiFeature])
      utils.detailMap.instance.setCenter(position, 14)


    close: ->
      $("#popup").addClass("hidden");


  ))