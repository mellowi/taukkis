define [], ->

  class GeoLocateControl extends Backbone.Model

    # constructor
    initialize: () ->
      geoLocateVector = new OpenLayers.Layer.Vector('geoLocate')

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
        console.log utils.currentLocation