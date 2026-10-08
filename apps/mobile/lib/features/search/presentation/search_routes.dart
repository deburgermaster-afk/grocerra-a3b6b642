import 'package:flutter/material.dart';

import 'search_results_screen.dart';
import 'search_screen.dart';

/// Routes for Figma section **D - Search** (`D1`, `D2` + `D-S1`-`D-S3`).
///
/// Owned by the search porting pass. Entry points are the search fields on
/// `B1` and `B2` and the address search on `A7`.
final Map<String, WidgetBuilder> searchRoutes = <String, WidgetBuilder>{
  SearchScreen.routeName: (BuildContext context) => const SearchScreen(),
  SearchResultsScreen.routeName: (BuildContext context) =>
      const SearchResultsScreen(),
};
