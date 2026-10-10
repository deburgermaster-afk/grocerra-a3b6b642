import 'package:flutter/material.dart';

import '../presentation/cart_screen.dart';
import '../presentation/carts_screen.dart';
import '../presentation/checkout_top_screen.dart';
import '../presentation/checkout_upsell_screen.dart';
import '../presentation/order_received_screen.dart';
import '../presentation/product_screen.dart';
import '../presentation/store_screen.dart';
import '../presentation/tip_screen.dart';

/// Routes for Figma section **B - Grocery order** (`B1`-`B11`).
///
/// Owned by the grocery-order porting pass. Add every pushed screen here so
/// `app.dart` can merge it without touching other sections.
///
/// The checkout flow runs cart → `/checkout/upsell` → `/checkout` →
/// `/checkout/tip` → (placing-order sheet) → `/order-confirmation`.
final Map<String, WidgetBuilder> shopRoutes = <String, WidgetBuilder>{
  '/carts': (BuildContext context) => const CartsScreen(),
  '/store': (BuildContext context) => const StoreScreen(),
  '/product': (BuildContext context) => const ProductScreen(),
  '/cart': (BuildContext context) => const CartScreen(),
  '/checkout': (BuildContext context) => const CheckoutTopScreen(),
  '/checkout/upsell': (BuildContext context) => const CheckoutUpsellScreen(),
  '/checkout/tip': (BuildContext context) => const TipScreen(),
  '/order-confirmation': (BuildContext context) =>
      const OrderReceivedScreen(),
};
