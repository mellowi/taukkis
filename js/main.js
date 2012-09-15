// RequireJS Configuration
require.config({
  
  // 3rd party script alias names (Easier to type "jquery" than "libs/jquery-1.7.2.min")
  paths: {
    // Core Libraries
    modernizr: "libs/modernizr-2.5.3",
    jquery: "libs/jquery-1.8.0",
    underscore: "libs/lodash-0.4.2",
    backbone: "libs/backbone-0.9.2",
    bootstrap: "libs/bootstrap.min",

    // Require.js Plugins
    text: "plugins/text-2.0.0",

    // Own libs
    settings: "settings",

    // CoffeeScript
    cs: 'libs/cs',
    'coffee-script': 'libs/coffee-script',
  
    // map
    openlayer: 'libs/OpenLayers.mobile.debug',
    googleapi: 'https://maps.google.com/maps/api/js?v=3.2&sensor=false',

    // json & cookies
    json: 'libs/jquery_cookie',
    jsoncookie: 'libs/jquery_jsoncookie',
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
require(['modernizr','jquery','backbone','openlayer','googleapi'], function(Modernizr, $, Backbone) {
  require(['bootstrap', 'json', 'jsoncookie', 'settings', 'cs!utils', 'cs!routers/router']);
});