var views = {};

var utils = {
  currentLocation: null,
  map: null,
  detailMap: null,
  destinationMap: null,
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

var categories = {
  "gas_station": {"fonectaId": "1D0050", "name": "Huoltoasemat" },
  "cafe": {"id": "1D1480", "name": "Kahvilat" },
  "kiosk": {"id": "1D1490", "name": "Kioskit" },
  "sights": {"id": "1D1220", "name": "Nähtävyydet" },
  "fast_food": {"id": "1D1520", "name": "Pikaruokalat" },
  "restaurant": {"id": "1D1530", "name": "Ravintolat" },
  "swimming_place": {"id": null, "name": "Uimapaikat" },
}