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
      "tap .category-filter": "categories"
    mapElement: "detail-map"

    render: (id) ->
      if(id == "undefined")
        return

      if(utils.route == null || utils.locations == null)
        utils.initFail()
        return

      views.header.render(@el)

      @pois = new Locations(utils.locations.getById(id)).models
      if(@pois.length != 1)
        utils.app.navigate "#error?reason=poi", true, true
        return;

      @poi = @pois[0].toJSON()
      $("#" + @el.id + " div[data-role='content']").html @template(
        location: @poi
      )

      @updateMap()
      @clearRoute()
      @clearPOILayer()
      @renderRoute()
      @renderPoi()


    categories: (e) ->
      utils.setCategory(e)


    renderPoi: ->
      position = utils.transformLonLat(@poi.lon, @poi.lat)
      poiFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(position.lon, position.lat))
      poiFeature.attributes = @poi
      @poiLayer.addFeatures([poiFeature])
      utils.detailMap.instance.setCenter(position, 14)

  ))