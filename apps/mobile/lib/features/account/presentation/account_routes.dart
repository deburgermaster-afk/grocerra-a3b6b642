import 'package:flutter/material.dart';

import '../../orders/presentation/orders_screen.dart';
import 'notification_screen.dart';

/// Routes for Figma section **F - Account & support** (`F1`-`F10`).
///
/// Owned by the account porting pass. `F1` Orders and `F2` Profile are shell
/// tabs wired through `HomeShell`; `F3`-`F10` are pushed from them.
final Map<String, WidgetBuilder> accountRoutes = <String, WidgetBuilder>{
  // `F1` Orders - placeholder until the order list lands. Pushed from the
  // Carts screen's "Orders" pill and later from the Profile tab.
  '/orders': (BuildContext context) => const OrdersScreen(),
  // `C23.01` Notifications - pushed from the Home bell (and Profile).
  NotificationScreen.routeName: (BuildContext context) =>
      const NotificationScreen(),
  // '/profile/favourites': (BuildContext context) => const FavouritesScreen(),
};
