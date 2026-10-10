import 'package:flutter/material.dart';

import 'browse_screen.dart';

/// Routes for Figma section **C07 - Browse** (`C07.01` `1:552`).
///
/// In the reference (5-tab shell) this route resolves to `HomeShell` on the
/// Browse tab so the floating bar is present. This app's shell has three
/// tabs (Home/Catering/Profile), so Browse is a plain pushed route.
final Map<String, WidgetBuilder> browseRoutes = <String, WidgetBuilder>{
  '/browse': (BuildContext context) => const BrowseScreen(),
};
