define [], ->

  class GeoLocateControl extends Backbone.Model

    # constructor
    initialize: () ->
      utils.geoLocateLayer = new OpenLayers.Layer.Vector("Locate")

      @instance = new OpenLayers.Control.Geolocate(
        {
        id: 'locate-control'
        geolocationOptions:
          {
          enableHighAccuracy: false
          maximumAge: 0
          timeout: 7000
          }
        }
      )

      @instance.events.register "locationupdated", @instance, (e) ->
        utils.currentLocation = {
          lat: e.position.coords.latitude
          lon: e.position.coords.longitude
        }
        utils.geoLocateLayer.removeAllFeatures()
        utils.geoLocateLayer.addFeatures([
          new OpenLayers.Feature.Vector(e.point
            null
            {
            graphicName: 'circle'
            strokeColor: '#f00'
            strokeWidth: 2
            fillOpacity: 0.6
            fillColor: '#f00'
            pointRadius: 8
            })
          ])
        if(utils.locations != null)
          utils.locations.updateAll()
          utils.locations.save()


      @instance.events.register "locationfailed", @instance, (e) ->
        utils.app.navigate "#error?reason=location", true, true

      @instance.events.register "locationuncapable", @instance, (e) ->
        utils.app.navigate "#error?reason=location", true, true
