import 'package:flutter/material.dart';

import '../../shell/presentation/home_shell.dart';
import 'kit/motion.dart';
import 'location_permission_screen.dart';

/// Where the flow hands over to the rest of the app.
abstract final class AuthFlow {
  /// Signed in: clear the auth stack and land on Home.
  static void goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      FadeThroughRoute<void>(page: const HomeShell(), scoped: false),
      (Route<dynamic> _) => false,
    );
  }

  /// New account confirmed: continue to location and delivery address.
  static void goToSetup(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      FadeThroughRoute<void>(
        page: const LocationPermissionScreen(),
        scoped: false,
      ),
      (Route<dynamic> _) => false,
    );
  }
}
