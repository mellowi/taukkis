define [
  "cs!models/geo-locate-control"
], (GeoLocateControl) ->

  class Map extends Backbone.Model

    # constructor
    initialize: (divname) ->
      @divname = divname

      mapQuest = @setLayerMapQuest()
      osmCycle = @setLayerOsmCycle()
      mmlTaustakartta = @setLayerMmlTaustakartta()
      bingHybrid = @setLayerBingHybrid()

      mapPosition = @loadMapPosition()

      @geolocate = new GeoLocateControl().instance;

      @controls = []
      if(@divname == "map" || @divname == "detail-map")
        @controls = [
          new OpenLayers.Control.Attribution()
          new OpenLayers.Control.TouchNavigation({
            dragPanOptions: {
              enableKinetic: true
            }
          })
          @geolocate
          new OpenLayers.Control.Zoom()
        ]

      if(@divname == "destination-map")
        @controls = [
          @geolocate
        ]

      @instance = new OpenLayers.Map
        div: @divname
        theme: null
        projection: defaults.projection
        controls: @controls
        layers: [
          mmlTaustakartta
        ]
        eventListeners:
          "moveend": @storeMapPosition

      @instance.setCenter(new OpenLayers.LonLat(mapPosition.longitude, mapPosition.latitude), mapPosition.zoom)
      @instance.setBaseLayer(mapQuest)
      if(@divname == "map" || @divname == "destination-map")
        control = @instance.getControlsBy("id", "locate-control")[0]
        control.activate()

      if(@divname == "map")
        @instance.events.register "movestart", map, (e) =>
          @removeTooltips()
        @instance.events.register "updatesize", map, (e) =>
          @removeTooltips()

      return @instance


    removeTooltips: ->
      $(".qtip").remove()


    storeMapPosition: (event) =>
      lonlat = event.object.getCenter();
      zoomLevel = event.object.getZoom();
      mapPosition = {
        longitude: lonlat.lon,
        latitude: lonlat.lat,
        zoom: zoomLevel
      }
      localStorage.setItem(@divname+'-position', JSON.stringify(mapPosition));
      #$.JSONCookie(@divname+'-position', mapPosition, {expires: 30})


    loadMapPosition: =>
      json = localStorage.getItem(@divname+'-position')
      position = JSON.parse(json)  if(json)
      # position = $.JSONCookie(@divname+'-position')
      position = {longitude: 2777381.0927341, latitude: 8439319.5947809, zoom: 11} unless position
      return position


    setLayerMapQuest: ->
      new OpenLayers.Layer.OSM(
        "MapQuest",
        [
          "http://otile1.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png",
          "http://otile2.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png",
          "http://otile3.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png",
          "http://otile4.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png"
        ],
        {
          transitionEffect: 'resize',
          attribution: "Data, imagery and map information provided by <a href='http://www.mapquest.com/'  target='_blank'>MapQuest</a>, <a href='http://www.openstreetmap.org/' target='_blank'>Open Street Map</a> and contributors, <a href='http://creativecommons.org/licenses/by-sa/2.0/' target='_blank'>CC-BY-SA</a>  <img src='http://developer.mapquest.com/content/osm/mq_logo.png' border='0'>"
        }
      )


    setLayerOsmCycle: ->
      new OpenLayers.Layer.OSM(
        "OpenStreetMap - Cycle",
        [
          "http://a.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
          "http://b.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
          "http://c.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png"
        ],
        { transitionEffect: 'resize' }
      )


    setLayerMmlTaustakartta: ->
      new OpenLayers.Layer.XYZ(
        "Maanmittauslaitos - Taustakartta",
        "http://tiles.kartat.kapsi.fi/taustakartta/${z}/${x}/${y}.png",
        {
          sphericalMercator: true,
          attribution:"<br/>Kartta-aineisto &copy; <a class='attribution' href='http://maanmittauslaitos.fi/'>MML</a>, jakelu <a class='attribution' href='http://kartat.kapsi.fi/'>Kapsi ry</a>",
          transitionEffect: 'resize'
        }
      )


    setLayerBingHybrid: ->
      new OpenLayers.Layer.Bing(
        {
          name: "Bing - Hybrid",
          key: defaults.bingKey, type: "AerialWithLabels",
          transitionEffect: 'resize'
        }
      )