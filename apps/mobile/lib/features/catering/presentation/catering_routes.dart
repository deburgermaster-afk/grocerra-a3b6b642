import 'package:flutter/material.dart';

import 'catering_checkout_screen.dart';
import 'catering_confirmation_screen.dart';
import 'catering_deposit_screen.dart';
import 'catering_orders_screen.dart';
import 'catering_quote_review_screen.dart';
import 'catering_request_details_screen.dart';
import 'catering_screen.dart';
import 'custom_menu_screen.dart';
import 'quote_event_screen.dart';

/// Routes for Figma section **C - Catering** (`C1`-`C8` + `C-S1`-`C-S4`).
///
/// Owned by the catering porting pass.
final Map<String, WidgetBuilder> cateringRoutes = <String, WidgetBuilder>{
  CateringScreen.routeName: (BuildContext context) =>
      const CateringScreen(),
  QuoteEventScreen.routeName: (BuildContext context) =>
      const QuoteEventScreen(),
  CustomMenuScreen.routeName: (BuildContext context) =>
      const CustomMenuScreen(),
  CateringConfirmationScreen.routeName: (BuildContext context) =>
      const CateringConfirmationScreen(),
  CateringQuoteReviewScreen.routeName: (BuildContext context) =>
      const CateringQuoteReviewScreen(),
  CateringCheckoutScreen.routeName: (BuildContext context) =>
      const CateringCheckoutScreen(),
  CateringDepositScreen.routeName: (BuildContext context) =>
      const CateringDepositScreen(),
  CateringRequestDetailsScreen.routeName: (BuildContext context) =>
      const CateringRequestDetailsScreen(),
  CateringOrdersScreen.routeName: (BuildContext context) =>
      const CateringOrdersScreen(),
};
