import 'package:flutter/material.dart';

import 'delete_account_screen.dart';
import 'help_support_screen.dart';
import 'legal_screen.dart';
import 'promotions_screen.dart';

/// Routes for the profile sub-pages of Figma section **F - Account**
/// (`F5`-`F9`): `C22.01` Promotions, `C25.01` Help & Support, `C26.01`
/// Legal & account and `C26.02` Delete account.
///
/// Split from `account_routes.dart` (which owns Orders / Favourites /
/// Notifications) so the two porting passes can run independently.
final Map<String, WidgetBuilder> accountExtraRoutes = <String, WidgetBuilder>{
  '/profile/promotions': (BuildContext context) => const PromotionsScreen(),
  '/profile/help': (BuildContext context) => const HelpSupportScreen(),
  '/profile/legal': (BuildContext context) => const LegalScreen(),
  '/profile/legal/delete': (BuildContext context) =>
      const DeleteAccountScreen(),
};
