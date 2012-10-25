var views = {};

var utils = {
	map: null
};

var defaults = {
  "rootUrl": "http://localhost:8000/api/api/v1/",
  "projection": "EPSG:900913",
  "projection2": "EPSG:4326",
  "bingKey": "AjiRFAOxAb5Z01PMW3EwdUrCjDhN88QKPA3OfFmUuheW4ByTUZ9XPySvAv50RUpR"
}

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