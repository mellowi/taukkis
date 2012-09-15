define [], ->

  class GeoLocateControl extends Backbone.Model

    # constructor
    initialize: (map) ->
      geoLocateVector = new OpenLayers.Layer.Vector('geoLocate')

      @instance = new OpenLayers.Control.Geolocate(
        {
        id: 'locate-control'
        type: OpenLayers.Control.TYPE_TOGGLE
        geolocationOptions:
          {
          enableHighAccuracy: false
          maximumAge: 0
          timeout: 7000
          }
        eventListeners:
          {
          activate: () ->
            map.addLayer(geoLocateVector)
          deactivate: () ->
            map.removeLayer(geoLocateVector);
            geoLocateVector.removeAllFeatures();
          locationupdated: (e) ->
            geoLocateVector.removeAllFeatures();
            geoLocateVector.addFeatures([
              new OpenLayers.Feature.Vector(e.point
                null
                {
                graphicName: 'cross'
                strokeColor: '#f00'
                strokeWidth: 2
                fillOpacity: 0
                pointRadius: 10
                })
              ])
          }
        }
      )

    getInstance: ->
      @instance