// RequireJS Configuration
require.config({

  // 3rd party script alias names (Easier to type "jquery" than "libs/jquery-1.7.2.min")
  paths: {
    // Core Libraries
    modernizr: "libs/modernizr-2.5.3",
    jquery: "libs/jquery-1.8.0",
    jquerymobile: "libs/jquery.mobile-1.1.0.min",
    underscore: "libs/lodash-0.4.2",
    backbone: "libs/backbone-0.9.2",
    bootstrap: "libs/bootstrap",

    // Require.js Plugins
    text: "plugins/text-2.0.0",

    // Own libs
    settings: "settings",

    // CoffeeScript
    cs: "libs/cs",
    "coffee-script": "libs/coffee-script",

    // map
    openlayer: "libs/OpenLayers.mobile",
    // googleapi: "https://maps.google.com/maps/api/js?v=3.2&sensor=false",
    routeboxer: "libs/RouteBoxer",

    // json & cookies
    json: "libs/jquery_cookie",
    jsoncookie: "libs/jquery_jsoncookie"
  },

  // Sets the configuration for your third party scripts that are not AMD compatible
  shim: {
    "backbone": {
      deps: ["underscore", "jquery"],
      exports: "Backbone"  //attaches "Backbone" to the window object
    }
  }

});

// Load the application
require(['modernizr','jquery','backbone', 'routeboxer','openlayer'], function(Modernizr, $, Backbone, RouteBoxer) {
  $(document).bind("mobileinit", function() {
    // no JQM routing
    $.mobile.ajaxEnabled = false;
    $.mobile.linkBindingEnabled = false;
    $.mobile.hashListeningEnabled = false;
    $.mobile.pushStateEnabled = false;

    $.mobile.autoInitializePage = true;
    $.mobile.loadingMessage = " ";
    $.mobile.defaultPageTransition = 'none';
    $.support.cors = true;
  });
  require(['bootstrap', 'jquerymobile', 'json', 'jsoncookie', 'settings', 'cs!utils', 'cs!routers/router']);
});