import 'package:flutter/material.dart';

import 'grocerra_map_stub.dart'
    if (dart.library.js_interop) 'grocerra_map_web.dart' as impl;

/// The checkout map strip: MapLibre GL — the engine `mapcn`'s React map is
/// built on — with CARTO's positron style (mapcn's default basemap),
/// centred on the delivery address. The pin, `Edit pin` pill and attribution
/// render in the map's own DOM layer on web; other platforms get a flat
/// placeholder until a mobile map plugin lands.
Widget buildGrocerraMap({
  required double lat,
  required double lng,
  required double zoom,
}) => impl.buildGrocerraMap(lat: lat, lng: lng, zoom: zoom);
