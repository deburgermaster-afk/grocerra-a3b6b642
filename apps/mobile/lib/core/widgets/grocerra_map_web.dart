import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// `window.grocerraInitMap` from `web/index.html` — MapLibre GL with CARTO
/// positron, plus the pin / pill / attribution DOM overlays.
@JS('grocerraInitMap')
external void _initMap(
  web.Element container,
  double lng,
  double lat,
  double zoom,
);

const String _viewType = 'grocerra-map';

bool _registered = false;

/// The checkout map strip, rendered by MapLibre GL inside a platform view.
///
/// Under CanvasKit the platform view is a DOM element layered over the
/// canvas, so everything drawn on the map (pin, pill, attribution) has to
/// live in that DOM too — see the init script in `web/index.html`.
Widget buildGrocerraMap({
  required double lat,
  required double lng,
  required double zoom,
}) {
  // Platform-view factories register once, outside `build` (the framework
  // contract). The checkout always shows the same address, so the first
  // call's coordinates are the ones captured by the factory.
  if (!_registered) {
    _registered = true;
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final web.HTMLDivElement div =
            web.document.createElement('div') as web.HTMLDivElement;
        div.style
          ..setProperty('width', '100%', '')
          ..setProperty('height', '100%', '')
          ..setProperty('border-radius', '20px', '')
          ..setProperty('overflow', 'hidden', '')
          ..setProperty('position', 'relative', '')
          // Decorative strip: the page underneath keeps scrolling and
          // tapping through it.
          ..setProperty('pointer-events', 'none', '');
        // The init script polls until the platform view has attached and
        // taken layout before building the map.
        _initMap(div, lng, lat, zoom);
        return div;
      },
    );
  }
  return const HtmlElementView(viewType: _viewType);
}
