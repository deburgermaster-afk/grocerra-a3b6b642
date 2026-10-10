import 'package:flutter/material.dart';

/// Non-web fallback: the MapLibre map only runs in a browser, so other
/// platforms see a flat strip in the map's tone.
Widget buildGrocerraMap({
  required double lat,
  required double lng,
  required double zoom,
}) {
  return const ColoredBox(color: Color(0xFFE8E7E4));
}
