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