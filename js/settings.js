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
  "bingKey": "<REMOVED>"
}

var categorySettings = {
  "gas_station": {"id": "1D0050", "name": "Huoltoasemat" },
  "cafe": {"id": "1D1480", "name": "Kahvilat" },
  "kiosk": {"id": "1D1490", "name": "Kioskit" },
  "sight": {"id": "1D1220", "name": "Nähtävyydet" },
  "fast_food": {"id": "1D1520", "name": "Pikaruokalat" },
  "restaurant": {"id": "1D1530", "name": "Ravintolat" },
  "swimming_place": {"id": null, "name": "Uimapaikat" },
  "leisure": {"id": null, "name": "Tulipaikat" },
}

var categoryDefault = {"id": null, "name": "Taukopaikka" }

// precipitation & precipitationtype
// weather 22 & 25
var weatherCodes = [
  // weather 22
  "pouta",
  "heikko",
  "kohtalainen",
  "runsas",
  "heikko",
  "kohtalainen",
  "runsas",
  // types 25
  "pouta", // 7
  "hyvin heikko sade, olomuotoa ei voida päätellä",
  "tihku",
  "vesisade",
  "lumisade",
  "märkä räntä",
  "räntä",
  "rakeita",
  "jääkiteitä",
  "lumijyväsiä",
  "lumirakeita",
  "jäätävä tihku",
  "jäätävä sade"
]

// roadsurfaceconditions1 & roadsurfaceconditions2
// weather 27, 28
var weatherRoadCodes = [
  "anturissa on vikaa",
  "kuiva",
  "kostea",
  "märkä",
  "märkä ja suolattu",
  "kuura",
  "lumi",
  "jää",
  "todennäköisesti kostea ja suolainen"
]

// warning1 & warning2
// weather 29, 30
var weatherWarningCodes = [
  "", // OK
  "Varo",
  "Häly",
  "Kuura",
  "Sade"
]
