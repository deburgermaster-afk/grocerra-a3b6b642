import 'package:flutter/material.dart';

import '../../orders/presentation/order_detail_screen.dart';
import '../../orders/presentation/orders_screen.dart';
import '../../orders/presentation/tracking_screen.dart';
import 'favourites_screen.dart';
import 'notification_screen.dart';

/// Routes for Figma section **F - Account & support** (`F1`-`F10`).
///
/// Owned by the account porting pass. `F2` Profile is a shell tab; the rest
/// are pushed from it. In the reference (5-tab shell) Orders is a tab - in
/// this app it is a pushed route.
final Map<String, WidgetBuilder> accountRoutes = <String, WidgetBuilder>{
  // `C15.01` Order history.
  OrdersScreen.routeName: (BuildContext context) => const OrdersScreen(),
  // `C15.02` Order details, pushed from an order row.
  OrderDetailScreen.routeName: (BuildContext context) =>
      const OrderDetailScreen(),
  // `C14` Tracking, pushed from the active-order card.
  TrackingScreen.routeName: (BuildContext context) => const TrackingScreen(),
  // `C23.01` Notifications - pushed from the Home bell (and Profile).
  NotificationScreen.routeName: (BuildContext context) =>
      const NotificationScreen(),
  // `F?` Favourites - pushed from the Profile row.
  FavouritesScreen.routeName: (BuildContext context) =>
      const FavouritesScreen(),
};
