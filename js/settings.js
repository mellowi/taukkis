var views = {};

var utils = {
  currentLocation: null,
  map: null,
  detailMap: null,
  route: null,
  locations: null,
  filter: null,
  initialized: false
};

var defaults = {
  "rootUrl": "http://localhost:8000/api/api/v1/",
  "projection": "EPSG:900913",
  "projection2": "EPSG:4326",
  "bingKey": "AjiRFAOxAb5Z01PMW3EwdUrCjDhN88QKPA3OfFmUuheW4ByTUZ9XPySvAv50RUpR"
}