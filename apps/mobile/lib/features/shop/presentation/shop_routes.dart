import 'package:flutter/material.dart';

import '../presentation/cart_screen.dart';
import '../presentation/checkout_top_screen.dart';
import '../presentation/product_screen.dart';
import '../presentation/store_screen.dart';

/// Routes for Figma section **B - Grocery order** (`B1`-`B11`).
///
/// Owned by the grocery-order porting pass. Add every pushed screen here so
/// `app.dart` can merge it without touching other sections.
final Map<String, WidgetBuilder> shopRoutes = <String, WidgetBuilder>{
  '/store': (BuildContext context) => const StoreScreen(),
  '/product': (BuildContext context) => const ProductScreen(),
  '/cart': (BuildContext context) => const CartScreen(),
  '/checkout': (BuildContext context) => const CheckoutTopScreen(),
};
