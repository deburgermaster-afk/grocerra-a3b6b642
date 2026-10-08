import 'package:flutter/material.dart';

import 'order_issue_choose_screen.dart';
import 'order_issue_details_screen.dart';
import 'order_issue_submitted_screen.dart';

/// Routes for Figma section **E - Order issue** (`E1`-`E3`).
///
/// Owned by the order-issue porting pass. Entered from tracking `Help`
/// (`B9`-`B11`) and from the catering order `Report an issue` (`C8`).
final Map<String, WidgetBuilder> supportRoutes = <String, WidgetBuilder>{
  OrderIssueChooseScreen.routeName: (BuildContext context) =>
      const OrderIssueChooseScreen(),
  OrderIssueDetailsScreen.routeName: (BuildContext context) =>
      const OrderIssueDetailsScreen(),
  OrderIssueSubmittedScreen.routeName: (BuildContext context) =>
      const OrderIssueSubmittedScreen(),
};
