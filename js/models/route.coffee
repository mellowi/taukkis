define [], () ->

  class Route extends Backbone.Model
    initialize: (googleDirections) ->
      @googleDirections = googleDirections
