import 'package:flutter/material.dart';

import '../data/sample_orders.dart';
import 'order_details_screen.dart';
import 'order_tracking_screen.dart';

/// Routes pushed from the `F1 · Orders` tab: order details and tracking
/// (`B9`). Both take the order id as the route argument; a deep link with no
/// (or an unknown) id opens the most recent order so the web preview still
/// lands on a real screen.
final Map<String, WidgetBuilder> ordersRoutes = <String, WidgetBuilder>{
  OrderDetailsScreen.routeName: (BuildContext context) =>
      OrderDetailsScreen(order: _orderFor(context)),
  OrderTrackingScreen.routeName: (BuildContext context) =>
      OrderTrackingScreen(order: _orderFor(context)),
};

Order _orderFor(BuildContext context) {
  final Object? id = ModalRoute.of(context)?.settings.arguments;
  return findOrder(id is String ? id : null) ?? sampleOrders.first;
}
